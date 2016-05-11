# spec/dice_set_spec.rb

require 'spec_helper'

describe Player do
  before(:all) {
    @player = Player.new(0)
  }

  describe "#new" do
    it "should return a new player object" do
      expect(@player).to be_a Player
    end
  end

  describe "#rollDice" do
    it "should roll dice and calculate the correct score" do
      allow(STDOUT).to receive(:puts) # this disables puts
      dice = DiceSet.new
      allow(dice).to receive(:values).and_return([1, 1, 1, 5, 3])
      expect(@player.rollDice(dice, 5)[0]).to eq(1050)
    end
  end

  describe "getValidDiceCount" do
    it "gives valid dice count after playing a turn" do
      numDice = 5
      values = [1, 1, 5, 3, 4]
      expect(@player.getValidDiceCount(numDice, values)).to eq(2)
    end

    it "returns 5 if all dices are scoring" do
      numDice = 3
      values = [1, 1, 5]
      expect(@player.getValidDiceCount(numDice, values)).to eq(5)
    end
  end

  describe "turn" do
    dice = DiceSet.new
    it "should return turn score as 0 if the roll is non-scoring" do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 1, 1, 4, 3], [5, 1], \
                                                 [4, 4])
      allow(@player).to receive(:gets).and_return("y", "y")
      @player.turn(dice)
      expect(@player.netScore).to eq(0)
    end

    it "should not append the turn score if it is < 300" do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 3, 6, 4, 3], [5, 3], [5])
      allow(@player).to receive(:gets).and_return("y", "y", "n")
      @player.turn(dice)
      expect(@player.netScore).to eq(0)
    end
    
    it "should return apt turn score if the rolls contain mixed values" do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 1, 5, 4, 3], [5, 3], [5])
      allow(@player).to receive(:gets).and_return("y", "y", "n")
      @player.turn(dice)
      expect(@player.netScore).to eq(350)
    end
    
    it "should store and retrieve the score from previous round" do
      expect(@player.netScore).to eq(350)
    end

    it "should offer 5 dice if the roll contains all scoring values" do
      allow(STDOUT).to receive(:puts) # this disables puts
      allow(dice).to receive(:values).and_return([1, 3, 1, 4, 3], [5, 5], \
                                                 [1, 1, 1, 4, 5])
      allow(@player).to receive(:gets).and_return("y", "y", "n")
      @player.turn(dice)
      expect(@player.netScore).to eq(1700)
    end
  end

end
