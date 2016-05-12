# A ruby program that mimics Greed Game interactively

require_relative 'game'

if __FILE__ == $PROGRAM_NAME
  puts 'Enter the number of players to play the game: (>= 1)'
  input_num_players = gets.strip.to_i
  game = Game.new(input_num_players)
  game.print_player_stats
  game.play_game
  game.fetch_winner
end
