require 'DealersHand'
require 'Deck'
require 'Card'
=begin

    This class represents the Dealer.
    player = Dealer.new('Dealer')

    The Dealer inherits from its parent class 'Player', the only difference being 
    that now, @is_dealer is true and that the @curr_hand is of the class DealersHand
    rather than just Hand. Likewise, the 

    methods: please see below and the comments above the different method sections

By: Olivia Wung

=end

class Dealer < Player

    def initialize(id)
    	super
    	@is_dealer = true
        @curr_hand = DealersHand.new(id)
    end

    def to_s
        "Dealer: hand #{self.reveal_hand}"
    end

    def get_id
    	"Dealer"
    end

    # ACTIONS AFFECTING HAND
    def restart_hand
        @curr_hand = DealersHand.new(@id)
    end

    # ACTIONS AFFECTING BANK
    # I made it none. I'm assuming dealer has infinite money.
    # I guess if someone really wanted to, they could play until they were
    # either broke, or get infinite money from the Dealer.

end