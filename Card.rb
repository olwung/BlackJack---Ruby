=begin

    This class represents a card.
    card = Card.new(suit, number)

    @@suits = card suits, from highest to lowest
    @@values = possible card values, containing 'A', 2-9, 'J', 'Q', 'K'

    e.g.
    card = Card.new('Spades', 'J')
        This would be the card Jack of Spades with a value of 10

    a Card has attributes :suit, :number, and :value
    as well as a method "to_s" which outputs the card suit, number (e.g. 'A' or '2'), and value

By: Olivia Wung

=end

class Card

    attr_reader :suit, :number, :value

    @@suits = ["Spades", "Hearts", "Diamonds", "Clubs"]

    values = Hash.new
    values["1"] = 1         # this represents an "A"
    values["11"] = 10       # this represents a "J"
    values["12"] = 10       # this represents a "Q"
    values["13"] = 10       # this represents a "K"
    2.upto(10) {|x| values[x.to_s] = x}
    @@cardValues = values

    def initialize(suitNumber, cardNumber)
        @suit = @@suits[suitNumber]
        @number = cardNumber
        @value = @@cardValues[@number.to_s]
    end

    def to_s
        case @number
        when 1
            "Ace of #{@suit} valued at either 1 or 11"
        when 11
            "Jack of #{@suit} valued at 10"
        when 12
            "Queen of #{@suit} valued at 10"
        when 13
            "King of #{@suit} valued at 10"
        else
            "#{@number} of #{@suit} valued at #{@value} "
        end
    end

  
end










