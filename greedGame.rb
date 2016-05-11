# A ruby program that will play the Greed Game
# Rules for the game are in GREED_RULES.txt

## DiceSet Class:
class DiceSet

  # Constructor
  def initialize
    @values = []
  end

  # Rolls dice to obtain valid random dice values
  def roll(number)
    @values = Array.new(number) {rand(1..6)}
  end

  # Returns values obtained from the last roll
  def values
    return @values
  end

end


## Calculates score for the currently rolled dice
def score(dice)
  return 0 if dice.size == 0
  totalScore = 0

  # countHash: stores count of each face value
  countHash = {}
  face = 1
  6.times do
    countHash[face] = dice.count(face)
    face += 1
  end

  countHash.each do |key, value|
    if countHash[key] >= 3
      totalScore += key * 100
      totalScore *= 10 if key == 1
      countHash[key] -= 3
    end

    totalScore += 100 * countHash[key] if key == 1
    totalScore += 50 * countHash[key] if key == 5
  end
  return totalScore
end


## Class Player
class Player
  attr_accessor :netScore, :id

  # Constructor
  def initialize(id)
    @id = id
    @netScore = 0
    @allowed = false
  end

  # Performs action for each turn of the player
  def turn(dice)
    accumulatedScore = 0
    stop = false
    numDice = 5

    while !stop do
      dice.roll(numDice)
      puts "Your dice values: #{dice.values}"
      rollScore = score(dice.values)
      puts "Roll score #{rollScore}"
      if rollScore == 0
        accumulatedScore = 0
        break
      end
      accumulatedScore += rollScore

      # Keeps only the non-scoring dice
      validDice = dice.values.select{ |e|
        e != 1 and e != 5 and dice.values.count(e) >= 3
      }
      if validDice.size >= 3
        numDice -= 3
      end
      validDice = dice.values.select{ |e| e == 1 or e == 5}
      numDice -= validDice.size
      if numDice == 0
        numDice = 5
      end

      puts "Would you like to roll again? [y/n]"
      playerInput = gets.strip
      if playerInput == "n"
        if @allowed == false and accumulatedScore >= 300
          @allowed = true
          puts "Turn score >= 300. Now your scores will be stored"
        elsif @allowed == false
          accumulatedScore = 0
          puts "Initial turn score < 300. Your scores won't be counted yet"
        end
        break
      end
    end

    @netScore += accumulatedScore
    puts "Total turn score: #{accumulatedScore}, net score: #{@netScore}"
  end
end


## Class Game
class Game

  # @@players represents array of all the player instances
  @@players = Array.new

  # Constructor
  def initialize(numPlayers)
    @dice = DiceSet.new
    @values = []

    @numPlayers = numPlayers
    i = 1
    numPlayers.times do
      player = Player.new(i)
      @@players << player
      i += 1
    end
  end

  # Keeps looping through each player for consecutive turns
  def playGame
    stopId = -1
    while true
      @@players.each do |player|
        if player.id == stopId
          return
        end

        puts "Player #{player.id} your turn"
        player.turn(@dice)
        if player.netScore >= 3000
          puts "Player #{player.id}, your score >= 3000"
          puts "\n**LAST ROUND**\n"
          stopId = player.id
        end
        printPlayerStats
      end
    end
  end

  # Outputs each player's attribute values
  def printPlayerStats
    playerStats = {}
    @@players.each do |player|
      playerStats[player.id] = player.netScore
    end
    puts "\n------------------------------------\nPlayer Stats"
    puts playerStats
    puts "------------------------------------\n\n"
  end

  # Iterates through player.netscore and fetches the winner
  def getWinner
    winnerId = -1
    winnerScore = 0
    @@players.each do |player|
      if player.netScore > winnerScore
        winnerId = player.id
      end
    end
    puts "Player #{winnerId} is the winner. Congratulations!"
  end
end


## Tests the above implemented Greed Game
def greedGame
  puts "Enter the number of players to play the game"
  inputNumPlayers = gets.strip.to_i
  if inputNumPlayers == 0
    puts "Game needs >= 1 player(s)"
    return
  end
  game = Game.new(inputNumPlayers)
  game.printPlayerStats
  game.playGame
  game.getWinner
end

greedGame
