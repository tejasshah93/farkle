## DiceSet Class
class DiceSet
  # Constructor
  def initialize
    @dice_values = []
  end

  # Rolls dice to obtain valid random dice values
  def roll(number)
    @dice_values = Array.new(number) { rand(1..6) }
  end

  # Returns values obtained from the last roll
  def values
    @dice_values
  end

  # Populates count_hash with appropriate face value counts
  def populate_count_hash(dice)
    count_hash = {}
    face = 1
    6.times do
      count_hash[face] = dice.count(face)
      face += 1
    end
    count_hash
  end

  # Calculates score for the currently rolled dice
  def score(dice)
    total_score = 0

    # count_hash: stores count of each face value
    count_hash = populate_count_hash(dice)

    count_hash.each do |key, _value|
      if count_hash[key] >= 3
        total_score += key * 100
        total_score *= 10 if key == 1
        count_hash[key] -= 3
      end

      total_score += 100 * count_hash[key] if key == 1
      total_score += 50 * count_hash[key] if key == 5
    end
    total_score
  end
end
