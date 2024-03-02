module HasOneAttachedLogFile
  extend ActiveSupport::Concern

  included do
    has_one_attached :log_file
    validate :unique_log_file

    private

    def unique_log_file
      return unless self.class.file_alreay_imported?(self.log_file.checksum)

      self.errors.add :log_file, 'already imported'
    end
  end

  class_methods do
    def file_alreay_imported?(checksum)
      self.joins(:log_file_blob).where(active_storage_blobs: {checksum:}).exists?
    end
  end
end
