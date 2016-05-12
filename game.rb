require_relative 'dice_set'
require_relative 'player'

# Class Game
class Game
  attr_reader :players

  # Constructor
  def initialize(num_players = 1)
    raise ArgumentError, 'Number of players must be >= 1' if num_players < 1

    @players = []
    @dice = DiceSet.new

    # Adds player object to @players array with auto_incremental ids
    i = 1
    num_players.times do
      player = Player.new(i)
      @players << player
      i += 1
    end
  end

  # Saves Id of the player who reaches 3000 first for looping one last time
  def last_round_condition(stop_id, player)
    if player.net_score >= 3000
      puts "Player #{player.id}, your score >= 3000"
      puts "\n**LAST ROUND**\n"
      stop_id = player.id if stop_id == -1
    end
    print_player_stats
    stop_id
  end

  # Keeps looping through each player for consecutive turns
  def play_game
    stop_id = -1
    catch :stop_game do
      loop do
        @players.each do |player|
          throw :stop_game if player.id == stop_id

          # Executes a player's turn
          player.turn(@dice)

          stop_id = last_round_condition(stop_id, player)
        end
      end
    end
  end

  # Outputs each player's attribute values
  def print_player_stats
    player_stats = {}
    @players.each do |player|
      player_stats[player.id] = player.net_score
    end

    puts "\n------------------------------------\nPlayer Stats"
    puts player_stats
    puts "------------------------------------\n\n"
  end

  # Iterates through player.netscore and fetches the winner
  def fetch_winner
    winner_id = -1
    winner_score = 0
    @players.each do |player|
      if player.net_score > winner_score
        winner_id = player.id
        winner_score = player.net_score
      end
    end
    puts "Player #{winner_id} is the winner. Congratulations!"
  end
end
