## Class Player

class Player

  attr_accessor :netScore, :id

  # Constructor
  def initialize(id)
    @id = id
    @netScore = 0
    @allowed = false
  end

  # Rolls dice and calculates roll score
  def rollDice(dice, numDice)
    dice.roll(numDice)
    values = dice.values
    puts "Your dice values: #{values}"
    rollScore = dice.score(values)
    puts "Roll score #{rollScore}"
    return [rollScore, values]
  end

  # Keeps only the non-scoring dice
  def getValidDiceCount(numDice, values)
    validDice = values.select{ |e|
      e != 1 and e != 5 and values.count(e) >= 3
    }
    if validDice.size >= 3
      numDice -= 3
    end

    validDice = values.select{ |e| e == 1 or e == 5}
    numDice -= validDice.size
    if numDice == 0
      numDice = 5
    end

    return numDice
  end

  # Updates netScore for a player
  def updateScore(accumulatedScore)
    @netScore += accumulatedScore
    return @netScore
  end

  # Performs action for each turn of the player
  def turn(dice)
    accumulatedScore = 0
    stop = false
    numDice = 5

    while !stop do
      # For each roll, rolls dice and calculates roll score
      rollScore, values = rollDice(dice, numDice)
      if rollScore == 0
        accumulatedScore = 0
        break
      end

      # accumulatedScore for that turn
      accumulatedScore += rollScore

      # Gets number of valid dice for next roll
      numDice = getValidDiceCount(numDice, values)

      # Interactive prompt asking whether to roll again or not
      puts "Would you like to roll again? [y/n]"
      playerInput = gets.strip
      if playerInput == "n"
        # if intial turn accumulatedScore < 300, scores are not stored
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

    # Updates @netScore by adding accumulatedScore for this turn
    updateScore(accumulatedScore)
    puts "Total turn score: #{accumulatedScore}, net score: #{@netScore}"
  end
end

