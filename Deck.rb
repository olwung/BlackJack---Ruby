require 'Card'

=begin

    This class represents a 52 card deck. No jokers
    deck = Deck.new

    This class inherits from Ruby's built in datastructure of array

By: Olivia Wung

=end

class Deck < Array

    def initialize
        13.times { 
            |cardValue|
            4.times { 
                |suitNumber|
                self << Card.new(suitNumber, cardValue + 1)
            }
        }
    end

end

