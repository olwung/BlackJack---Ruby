#Blackjack game

=begin

BlackJack Game Information
Card Values:
    -Ace: either 1 or 11
    -2-9: face value
    -10,J,Q,K: value of 10

Actions:
    -hit: takes card from dealer
        -special case: dealer must hit if below 16
    -stand/stay: take no more cards
        -special case: dealer must stay if he has card total of 17 or more
    -double down: player allowed to increase initial bet by up to 100%
        in exchange for commiting to stand after recieving exactly one more card.
        This additional bet is placed in the betting box next to the original bet.
        Non-controlling players must double their wager or decline, but are bound by
        the controlling player's decision to take only one card
    -split: Only available as the first decision of a hand**
        If first two cards are equal in value, player can split them into 2 hands
        by moving a second bet equal to the first into an area outside the betting box
        (Essentially like playing 2 hands)
    -surrender: You lose.
    -bust: Your hand goes over 21 (not actually an action)

Other Notes:
    -goal: get 21 (or as close to it as possible without busting)
    -players: 2+, usually 2-6
    -go clockwise
    -dealer doesn't change
    -did you know it has a French Origin?


Documentation about blackjack.rb
Functions:
    -startGame: begins the game
    -playerSetup: talks with the player and gathers information about total players
    -blackJackGame: sets up and plays the actual game

By: Olivia Wung

=end
require 'Deck'
require 'Hand'
require 'DealersHand'
require 'Player'
require 'Dealer'
require 'BlackJackGame'


# CODE START - FUNCTIONS

def blackJackGame(players)
    game = BlackJackGame.new(players)
    game.game_start #sets up the game
    while game.in_play do
        game.setup_bets
        # puts "dealing cards"
        game.deal_cards
        # puts "starting round"
        game.play_round
    end
    puts "Thanks for playing!"
end

def playerSetup
    puts "How many players will be playing today? The table fits only up to 6."
    playerCount = gets.chomp.to_i
    if playerCount < 2
        puts "Sorry, you must have at least 2 players"
        playerSetup
    elsif playerCount >= 2 && playerCount <= 6
        puts "Alright! Take your seats and let us begin!"
        blackJackGame(playerCount - 1)
    else
        puts "Please give me a valid number between, and including, 2 and 6."
        playerSetup
    end
end

def startGame
    puts "Ready to play Blackjack? Reply 'yes' to begin and 'no' to quit"
    input = gets.chomp.lstrip.rstrip
    case input
    when 'no'
        game = false
        puts "Alright, maybe next time then."
    when 'yes'
        puts "Great! Let's begin!"
        playerSetup
    else
        puts "Pardon, I didn't get that. Please repeat."
        startGame
    end
    # if gets.chomp.downcase.rstrip.lstrip == "yes"
    #     puts "Great! Let's begin!"
    #     playerSetup
    # elsif gets.chomp.downcase.lstrip.rstrip == "no"
    #     puts "Alright, maybe next time then."
    #     game = false
    # else
    #     puts "Pardon, I didn't get that"
    #     startGame
    # end
end


# MAIN FUNCTION TO BE RUN

game = true
while game do
    startGame
    if game
        puts "Would you like to play again? Reply 'yes' to play again."
        if gets.chomp.downcase.lstrip.rstrip != "yes"
            game = false
        end
    else
        puts "Alright! Goodbye! :)"
    end
end
puts "Alright! Goodbye! :)"


