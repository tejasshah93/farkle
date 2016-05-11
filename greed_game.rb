# A ruby program that mimics Greed Game interactively

require_relative 'dice_set'
require_relative 'player'
require_relative 'game'

if __FILE__ == $0
  puts "Enter the number of players to play the game: (>= 1)"
  inputNumPlayers = gets.strip.to_i
  game = Game.new(inputNumPlayers)
  game.printPlayerStats
  game.playGame
  game.getWinner
end

