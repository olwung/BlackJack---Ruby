require 'Card'
require 'Deck'
=begin

    This class represents a player's hand.
    hand = Hand.new(id)

    A hand has attributes @cards, @id (identifies which player's hand), and many booleans
    regarding what card it is on (first, second, or past that), whether or not the hand
    has an ace (@has_ace), whether or not it is split, or if double down has been called,
    or if the Hand holder has called "stay". There is also a total value of the cards.
    There is a @max_card_limit that doesn't really come into play unless @double is true.

    methods: please see below and the comments above the different method sections.
    
By: Olivia Wung

=end


class Hand < Array

    attr_reader :cards, :id, :has_ace

    def initialize(id)
        @id = id
        @first_card = true
        @second_card = false
        @cards = []
        @has_ace = false
        @is_split = false
        @stay = false
        @double = false
        @total_value = 0
        @max_card_limit = 10     # this is only affected and used when double is true
    end

    # A to string method that outputs the cards
    def to_s
        @cards.each {
            |x| x.to_s
        }
    end

    # Adds up the card values, sets it to @total_values and returns the value
    def total_value
        total = 0
        @cards.each {
            |x| total += x.value
        }
        if @has_ace && (total + 10 <= 21)
            total += 10
        end
        @total_value = total
        return @total_value
    end

    # ACTIONS
    def add_card(x)
        if @cards.count < @max_card_limit   # this check only really matters for when double down is called
            @cards << x
            if (x.value == 1)
                @has_ace = true
            end
            if @first_card
                @first_card = false
                @second_card = true
                puts "Player #{id} is delt a " << x.to_s
            elsif @second_card
                @second_card = false
                puts "Player #{id} is delt a facedown card."
            else
                puts "Looking at cards... Player has:"
                puts self.to_s
            end
        end
    end

    def count
        @cards.count
    end

    def hit(x)
        @cards << x
    end

    def stay
        @stay = true
    end

    # STATES
    def bust
        self.total_value > 21
    end

    def can_hit
        self.total_value <= 21
    end

    def blackjack
        self.total_value == 21
    end

    def is_split
        @is_split = true
    end

    def can_double
        @double
    end

    # This method is activated when the player calls 'double down'
    def double_down
        @double = true
        @max_card_limit = @cards.count + 1
    end

    def can_split
        @cards[0].value == @cards[1].value
    end

    # This method is called when the player calls 'split'
    def split_hand
        newHand = Hand.new(@id)
        newHand.is_split
        newHand.add_card(@cards.pop)
        @is_split = true
        return newHand
    end

end