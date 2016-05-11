## Class Game

class Game

  attr_reader :players

  # Constructor
  def initialize(numPlayers = 1)
    if numPlayers < 1
      raise ArgumentError, "Number of players must be >= 1"
    end

    @players = Array.new
    @dice = DiceSet.new
    @values = []
    @numPlayers = numPlayers

    # Adds player object to @players array with auto_incremental ids
    i = 1
    numPlayers.times do
      player = Player.new(i)
      @players << player
      i += 1
    end
  end

  # Saves Id of the player who reaches 3000 first for looping one last time
  def lastRoundCondition(stopId, player)
    if player.netScore >= 3000
      puts "Player #{player.id}, your score >= 3000"
      puts "\n**LAST ROUND**\n"
      if stopId == -1
        stopId = player.id
      end
    end
    return stopId
  end

  # Keeps looping through each player for consecutive turns
  def playGame
    stopId = -1
    while true
      @players.each do |player|
        if player.id == stopId
          return
        end

        puts "Player #{player.id} your turn"
        # Executes a player's turn
        player.turn(@dice)

        stopId = lastRoundCondition(stopId, player)
        printPlayerStats
      end
    end
  end

  # Outputs each player's attribute values
  def printPlayerStats
    playerStats = {}
    @players.each do |player|
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
    @players.each do |player|
      if player.netScore > winnerScore
        winnerId = player.id
        winnerScore = player.netScore
      end
    end
    puts "Player #{winnerId} is the winner. Congratulations!"
  end
end

