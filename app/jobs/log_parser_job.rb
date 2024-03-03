class LogParserJob < ApplicationJob
  queue_as :default

  around_perform :update_status

  def perform(*args)
    Parser.call(*args)
  end

  private

  def update_status
    import = self.arguments.first

    import.update! status: Import::PARSING
    yield
    import.update! status: Import::PARSED
  rescue StandardError => e
    import.update! status: Import::ERROR, error_message: e.message
  end
end
