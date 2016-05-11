# spec/dice_set_spec.rb

require 'spec_helper'

describe DiceSet do
  before :each do
    @dice  = DiceSet.new
  end

  describe "#new" do
    it "can create a dice set"  do
      expect(@dice).not_to be_nil
    end
  end

  it "returns an array of integers between 1-6" do
    expect(@dice.roll(5)).to be_an(Array)
    @dice.values.each do |value|
      expect(value).to be_between(1, 6).inclusive
    end
  end

  it "should not change values unless explicitly rolled" do
    first_time = @dice.values
    second_time = @dice.values
    expect(first_time).to eq(second_time)
  end

  it "should change values when explicitly rolled" do
    @dice.roll(5)
    first_time = @dice.values

    @dice.roll(5)
    second_time = @dice.values

    expect(first_time).not_to eq(second_time)
  end

  it "can roll different numbers of dice" do
    @dice.roll(3)
    expect(@dice.values.size).to eq(3)

    @dice.roll(1)
    expect(@dice.values.size).to eq(1)
  end

  describe "#score" do
    it "returns 0 for empty list" do
      expect(@dice.score([])).to eq(0)
    end

    it "returns 50 for a single roll of 5" do
      expect(@dice.score([5])).to eq(50)
    end

    it "returns 100 for a single roll of 1" do
      expect(@dice.score([1])).to eq(100)
    end

    it "returns sum of individual scores for multiples of 1s and 5s < 3" do
      expect(@dice.score([1, 5, 5, 1])).to eq(300)
    end

    it "returns 0 for single 2s 3s 4s 6s" do
      expect(@dice.score([2, 3, 4, 6])).to eq(0)
    end

    it "returns 1000 for a triple of 1s" do
      expect(@dice.score([1, 1, 1])).to eq(1000)
    end

    it "returns 100x for every other triples" do
      expect(@dice.score([2, 2, 2])).to eq(200)
      expect(@dice.score([3, 3, 3])).to eq(300)
      expect(@dice.score([4, 4, 4])).to eq(400)
      expect(@dice.score([6, 6, 6])).to eq(600)
    end

    it "returns sum for mixed values" do
      expect(@dice.score([2, 5, 2, 2, 3])).to eq(250)
      expect(@dice.score([5, 5, 5, 5])).to eq(550)
      expect(@dice.score([1, 1, 1, 1])).to eq(1100)
      expect(@dice.score([1, 1, 1, 1, 1])).to eq(1200)
      expect(@dice.score([1, 1, 1, 5, 1])).to eq(1150)
    end
  end
end

