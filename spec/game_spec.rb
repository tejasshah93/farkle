# spec/dice_set_spec.rb

require 'spec_helper'

describe Game do
  before :each do
    @game = Game.new(2)
  end

  describe "#new" do
    it "should return a new game object" do
      expect(@game).to be_a Game 
    end

    it "raises ArgumentError when input number of players are < 1" do
      expect {Game.new(0)}.to raise_error(ArgumentError)
    end

    it "should create number of players equal to the input" do
      expect(@game.players.size).to eq(2)
    end
  end
  
  describe "#getWinner" do
    it "should return a winner player with max score" do
      @game.players[0].netScore = 300
      @game.players[1].netScore = 200
      expect {@game.getWinner}. \
        to output("Player 1 is the winner. Congratulations!\n").to_stdout
      
      @game.players[0].netScore = 200
      @game.players[1].netScore = 300
      expect {@game.getWinner}. \
        to output("Player 2 is the winner. Congratulations!\n").to_stdout
    end
  end
  
  describe "#playGame" do
    it "should loop through each player for his/her turn" do
      allow(STDOUT).to receive(:puts) # this disables puts
      @game.players.each do |player|
        allow(player).to receive(:turn)
        expect(player).to receive(:turn)
        if player.id == @game.players.size
          player.netScore = 3000
        end
      end
      @game.playGame
    end
  end

  describe "#lastRoundCondition" do
    it "should set stopId if a player's score reaches 3000" do
      allow(STDOUT).to receive(:puts) # this disables puts
      @game.players[0].netScore = 3000
      player1 = @game.players[0]
      expect(@game.lastRoundCondition(-1, player1)).to eq(1)
    end
  end

end
