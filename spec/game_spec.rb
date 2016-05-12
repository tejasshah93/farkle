# spec/dice_set_spec.rb

require 'spec_helper'

describe Game do
  before :each do
    @game = Game.new(2)
  end

  describe '#new' do
    it 'should return a new game object' do
      expect(@game).to be_a Game
    end

    it 'raises ArgumentError when input number of players are < 1' do
      expect { Game.new(0) }.to raise_error(ArgumentError)
    end

    it 'should create number of players equal to the input' do
      expect(@game.players.size).to eq(2)
    end
  end

  describe '#fetch_winner' do
    it 'should return a winner player with max score' do
      @game.players[0].net_score = 300
      @game.players[1].net_score = 200
      expect { @game.fetch_winner }
        .to output("Player 1 is the winner. Congratulations!\n").to_stdout

      @game.players[0].net_score = 200
      @game.players[1].net_score = 300
      expect { @game.fetch_winner }
        .to output("Player 2 is the winner. Congratulations!\n").to_stdout
    end
  end

  describe '#play_game' do
    it 'should loop through each player for his/her turn' do
      allow(STDOUT).to receive(:puts) # this disables puts
      @game.players.each do |player|
        allow(player).to receive(:turn)
        expect(player).to receive(:turn)
        player.net_score = 3000 if player.id == @game.players.size
      end
      @game.play_game
    end
  end

  describe '#last_round_condition' do
    it 'should set stopId if a player score reaches 3000' do
      allow(STDOUT).to receive(:puts) # this disables puts
      @game.players[0].net_score = 3000
      player1 = @game.players[0]
      expect(@game.last_round_condition(-1, player1)).to eq(1)
    end
  end
end
