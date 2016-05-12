## Class Player
class Player
  attr_accessor :net_score, :id, :allowed

  # Constructor
  def initialize(id)
    @id = id
    @net_score = 0
    @allowed = false
  end

  # Rolls dice and calculates roll score
  def roll_dice(dice, num_dice)
    dice.roll(num_dice)
    values = dice.values
    puts "Your dice values: #{values}"
    roll_score = dice.score(values)
    puts "Roll score #{roll_score}"
    [roll_score, values]
  end

  # Keeps only the non-scoring dice
  def get_valid_dice_count(num_dice, values)
    valid_dice = values.select { |e| e != 1 && e != 5 && values.count(e) >= 3 }
    num_dice -= 3 if valid_dice.size >= 3

    valid_dice = values.select { |e| e == 1 || e == 5 }
    num_dice -= valid_dice.size
    num_dice = 5 if num_dice == 0

    num_dice
  end

  # Updates net_score for a player
  def update_score(accumulated_score)
    @net_score += accumulated_score
    puts "Total turn score: #{accumulated_score}, net score: #{@net_score}"
    @net_score
  end

  # Returns accumulated score after validating initial turn condition
  def valid_init_turn(accumulated_score)
    # if intial turn accumulated_score < 300, scores are not stored
    if @allowed == false && accumulated_score >= 300
      @allowed = true
      puts 'Turn score >= 300. Now your scores will be stored'
    elsif @allowed == false
      accumulated_score = 0
      puts "Initial turn score < 300. Your scores won't be counted yet"
    end
    accumulated_score
  end

  # For each roll, rolls dice and calculates roll score
  def each_roll(dice, num_dice, accumulated_score)
    roll_score, values = roll_dice(dice, num_dice)
    if roll_score == 0
      accumulated_score = 0
    else
      # accumulated_score for that turn
      accumulated_score += roll_score

      # Gets number of valid dice for next roll
      num_dice = get_valid_dice_count(num_dice, values)
    end
    [num_dice, accumulated_score]
  end

  # Performs action for each turn of the player
  def turn(dice)
    accumulated_score = 0
    num_dice = 5

    puts "Player #{@id}, your turn"
    loop do
      num_dice, accumulated_score = each_roll(dice, num_dice, accumulated_score)
      break if accumulated_score == 0

      # Interactive prompt asking whether to roll again or not
      puts 'Would you like to roll again? [y/n]'
      next unless gets.strip == 'n'

      accumulated_score = valid_init_turn(accumulated_score)
      break
    end

    # Updates @net_score by adding accumulated_score for this turn
    update_score(accumulated_score)
  end
end
