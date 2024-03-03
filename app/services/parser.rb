class Parser < Struct.new(:import)
  INIT_GAME = /^\s*\d+:\d{2} InitGame: /
  NEW_PLAYER = /^\s*\d+:\d{2} ClientUserinfoChanged: \d+ n\\(.*?)\\/
  KILLER_VICTIM = /^\s*\d+:\d{2} Kill: \d+ \d+ \d+: (.+) killed (.+) by (MOD_[A-Z_]+)$/

  def self.call(import)
    new(import).call
  end

  def call
    match = nil
    stats = nil

    ApplicationRecord.transaction do # atomic persistence
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

      match.create_cache_report!(stats:)
    end
  end

  private

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
