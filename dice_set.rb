## DiceSet Class
#
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

  # Calculates score for the currently rolled dice
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

end
