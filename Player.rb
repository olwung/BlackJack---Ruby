require 'Hand'
require 'Deck'
require 'Card'
=begin

    This class represents a player.
    player = Player.new(id)

    A player is initialized with an id number, $1000, an empty hand, and a bet of 0.
    For a regular player, attribute @is_dealer is set to false and @split is also set to false
    
    methods: please see below and the comments above the different method sections

By: Olivia Wung

=end

class Player

    attr_reader :id, :is_dealer, :money, :curr_hand, :bet, :insurance

    def initialize(id)
        @id = id
        @money = 1000
        @curr_hand = Hand.new(id)
        @bet = 0
        @is_dealer = false
        @split = false
        @insurance = false
    end

    # This method returns a string describing the player in question
    def to_s
        "Player #{@id}: hand #{self.get_hand.to_s} with total money of #{@money}. Current bet is #{@bet}."
    end

    # This method returns the player's ID number (e.g. Player 1)
    def get_id
        "Player #{@id}"
    end

    # This method changes the insurance from false to true
    def insured
        @insurance = (not @insurance)
    end

    # Player can only split once as first move (according to Wikipedia); once split, can no longer split again
    def is_split
        @split
    end

    # This is called when a split player's hand is reset
    def unsplit
        @split = false
    end

    # Prints out the current hand
    def reveal_hand
        @curr_hand.to_s
    end

    # Returns true if player has less than 5 dollars.
    def is_broke
        @money < 5
    end

    # BELOW ARE ACTIONS AFFECTING HANDS
    def restart_hand
        @curr_hand = Hand.new(@id)
        @bet = 0
    end

    # BELOW ARE ACTIONS AFFECTING YOUR MONEY
    def add_money(x)
        @money += x
    end

    def make_bet(x)
        @bet += x
    end

    # BELOW ARE ACTIONS FOR THE PLAYER
    def splithand
        if @curr_hand.can_split
            @split = true
            @curr_hand.split_hand
        end
    end

    def double
        @curr_hand.double_down
        @bet = @bet * 2
    end

end