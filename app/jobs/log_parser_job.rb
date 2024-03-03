class LogParserJob < ApplicationJob
  queue_as :default

  around_perform :update_status

  INIT_GAME = /^\s*\d+:\d{2} InitGame: /
  NEW_PLAYER = /^\s*\d+:\d{2} ClientUserinfoChanged: \d+ n\\(.*?)\\/
  KILLER_VICTIM = /^\s*\d+:\d{2} Kill: \d+ \d+ \d+: (.+) killed (.+) by (MOD_[A-Z_]+)$/

  def perform(import)
    current_game = 0
    match = nil
    stats = nil

    import.log_file.open do |file| # downloads file
      file.each_line do |line|     # reads file line by line so that RAM doesn't explode
        case line
        when INIT_GAME
          match.create_cache_report!(stats:) if match.present?
          match = import.matches.create!
          stats = build_stats
        when NEW_PLAYER
          record_player($1, stats)
        when KILLER_VICTIM
          record_kill($1, $2, $3, match, stats)
        end
      end
    end
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

  def build_stats
    {
      "total_kills": 0,
      "players": Set.new,
      "kills": {},
      "kills_by_means": Hash.new { |hsh, key| hsh[key] = 0 }
    }
  end

  def record_player(player_name, stats)
    stats[:players] << player_name
    stats[:kills][player_name] ||= 0
  end

  def record_kill(killer, victim, means, match, stats)
    stats[:kills][killer] += 1 unless killer == "<world>"
    stats[:kills][victim] -= 1 if killer == "<world>"
    stats[:kills_by_means][means] += 1
    stats[:total_kills] += 1

    match.kills.create!(killer:, victim:, means:)
  end
end
