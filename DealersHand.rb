require 'Card'
=begin

    This class represents the dealer's hand.
    hand = DealersHand.new(id)

    The Dealer's hand inherits from it's parent class, 'Hand', all the same initial variables.
    However, it is also initialized with booleans @under_17 = true, @third_card = false, @blackjack = false,
    as well as a @first_card_holder that is used to reveal the first facedown card delt by the dealer
    when their turn comes around after all the players have gone.

    methods: please see below and the comments above the different method sections.

By: Olivia Wung

=end


class DealersHand < Hand

    attr_reader :insurance

    def initialize(id)
        super
        @under_17 = true
        @third_card = false
        @first_card_holder = nil
        @blackjack = false
        @insurance = false
    end

    # This method overrides the original Hand's method as cards are shown a little differently
    # between regular players and the dealer
    def add_card(x)
        @cards << x
        if @first_card
            @first_card = false
            @first_card_holder = x.to_s
            @second_card = true
            puts "Dealer deals himself a facedown card."
        elsif @second_card
            @second_card = false
            puts "Dealer deals himself a " + x.to_s + "."
            if x.value == 10:
                puts "Dealer is checking for blackjack..."
                if self.total_value == 21:
                    @blackjack = true
                    puts "Blackjack!"
                end
            elsif x.value == 1:
                puts "Would you like insurance?"
                @insurance = true
            end

        elsif @third_card
            @third_card = false
            puts "Dealer reveals first card: #{@first_card_holder}."
            puts "Dealer deals himself a " + x.to_s + ". Total #{self.total_value}"
        else
            puts "Dealer deals himself a " + x.to_s + ". Total #{self.total_value}"
        end
    end

    # This method returns true if the dealer has blackjack and false otherwise when called
    def has_blackjack
        @blackjack
    end

    # This method returns true if the dealer has a hand valued under 17
    def must_hit
        self.total_value < 17
    end

    # This method returns true if the deaher has a hand valued at or above 17
    def must_stay
        self.total_value >= 17
    end

end