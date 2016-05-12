# spec/dice_set_spec.rb

require 'spec_helper'

describe Player do
  before :each do
    @player = Player.new(0)
  end

  describe '#new' do
    it 'should return a new player object' do
      expect(@player).to be_a Player
    end
  end

  describe '#roll_dice' do
    it 'should roll dice and calculate the correct score' do
      allow(STDOUT).to receive(:puts) # this disables puts
      dice = DiceSet.new
      allow(dice).to receive(:values).and_return([1, 1, 1, 5, 3])
      expect(@player.roll_dice(dice, 5)[0]).to eq(1050)
    end
  end

  describe '#get_valid_dice_count' do
    it 'gives valid dice count after playing a turn' do
      num_dice = 5
      values = [1, 1, 5, 3, 4]
      expect(@player.get_valid_dice_count(num_dice, values)).to eq(2)
    end

    it 'returns 5 if all dices are scoring' do
      num_dice = 3
      values = [1, 1, 5]
      expect(@player.get_valid_dice_count(num_dice, values)).to eq(5)
    end
  end

  describe '#each_roll' do
    it 'should return accumulated score 0 if roll score is 0' do
      allow(STDOUT).to receive(:puts) # this disables puts
      dice = DiceSet.new
      allow(dice).to receive(:roll).and_return([])
      expect(@player.each_roll(dice, 5, 100)[1]).to eq(0)
    end
  end

  describe '#valid_init_turn' do
    it 'should not add accumulated score < 300 if allowed == false' do
      allow(STDOUT).to receive(:puts) # this disables puts
      @player.allowed = false
      expect(@player.valid_init_turn(200)).to eq(0)
    end

    it 'should save accumulated score > 0 if allowed == true' do
      @player.allowed = true
      expect(@player.valid_init_turn(100)).to eq(100)
    end
  end

  describe '#turn' do
    dice = DiceSet.new
    it 'should return turn score as 0 if the roll is non-scoring' do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 1, 1, 4, 3], [5, 1], \
                                                 [4, 4])
      allow(@player).to receive(:gets).and_return('y', 'y')
      @player.turn(dice)
      expect(@player.net_score).to eq(0)
    end

    it 'should not append the turn score if it is < 300' do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 3, 6, 4, 3], [5, 3], [5])
      allow(@player).to receive(:gets).and_return('y', 'y', 'n')
      @player.turn(dice)
      expect(@player.net_score).to eq(0)
    end

    it 'should return apt turn score if the rolls contain mixed values' do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 1, 5, 4, 3], [5, 3], [5])
      allow(@player).to receive(:gets).and_return('y', 'y', 'n')
      @player.turn(dice)
      expect(@player.net_score).to eq(350)
    end

    it 'should store and retrieve the score from previous round' do
      @player.net_score = 350
      expect(@player.net_score).not_to eq(0)
    end

    it 'should offer 5 dice if the roll contains all scoring values' do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 3, 1, 4, 3], [5, 5], \
                                                 [1, 1, 1, 4, 5])
      allow(@player).to receive(:gets).and_return('y', 'y', 'n')
      @player.turn(dice)
      expect(@player.net_score).to eq(1350)
    end
  end
end
