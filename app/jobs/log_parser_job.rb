class LogParserJob < ApplicationJob
  queue_as :default

  INIT_GAME = /^\s*\d+:\d{2} InitGame: /
  NEW_PLAYER = /^\s*\d+:\d{2} ClientUserinfoChanged: \d+ n\\(.*?)\\/
  KILLER_VICTIM = /^\s*\d+:\d{2} Kill: \d+ \d+ \d+: (.+) killed (.+) by (MOD_[A-Z_]+)$/

  def perform(import)
    games_data = {}.with_indifferent_access
    current_game = 0

    import.log_file.open do |file| # downloads file
      file.each_line do |line|     # reads file line by line so that RAM doesn't explode
        case line
        when INIT_GAME
          record_start(games_data, current_game += 1)
        when NEW_PLAYER
          record_player($1, games_data, current_game)
        when KILLER_VICTIM
          record_kill($1, $2, $3, games_data, current_game)
        end
      end
    end
  end

  private

  def record_start(games_data, current_game)
    games_data["game_#{current_game}"] = {
      "total_kills": 0,
      "players": Set.new,
      "kills": {},
      "kills_by_means": Hash.new { |hsh, key| hsh[key] = 0 }
    }
  end

  def record_player(player_name, games_data, current_game)
    games_data["game_#{current_game}"][:players] << player_name
    games_data["game_#{current_game}"][:kills][player_name] ||= 0
  end

  def record_kill(killer, victim, mean, games_data, current_game)
    games_data["game_#{current_game}"][:kills][killer] += 1 unless killer == "<world>"
    games_data["game_#{current_game}"][:kills][victim] -= 1 if killer == "<world>"
    games_data["game_#{current_game}"][:kills_by_means][mean] += 1
    games_data["game_#{current_game}"][:total_kills] += 1
  end
end
