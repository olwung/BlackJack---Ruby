require 'Deck'
require 'Hand'
require 'DealersHand'
require 'Player'
require 'Dealer'
=begin

    This class is basically the entire game.
    game = BlackJackGame.new(players)

    Is initialixed @in_play = true with a minimum bet at $5 and with the number
    of players given by the person running the code.
    There is a players list as well as their hand values.
    A shuffled deck is also generated in @bjdeck

    methods: please see below and the comments above the different method sections

=end

class BlackJackGame

    attr_reader :in_play, :bjdeck

    # The initial methods and values
    def initialize(players)
        @in_play = true
        @min_bet = 5
        @total_players = players
        @player_list = []
        @player_hand_values = []
        @bjdeck = Deck.new.shuffle
    end
    
    # This method initializes the game
    def game_start
        i = 1
        for i in 1..@total_players do
            # puts "Player #{i} being created"
            @player_list << Player.new(i)
        end
        @player_list << Dealer.new('Dealer')
    end

    # This method sets up bets for the players
    # There are a few checks to be run through in this method
    def setup_bets
        @bjdeck = Deck.new.shuffle
        @player_list.each {
            |player|
            valid_bet = false
            unless player.is_dealer
                unless player.is_broke
                    while (not valid_bet)
                        puts "Player #{player.get_id}, how much would you like to bet? Minimum bet is $5. Please enter an integer value."
                        bet = gets.chomp.to_i
                        if (bet >= 5) && (bet <= player.money)
                            player.make_bet(bet)
                            valid_bet = true
                        else
                            puts "Invalid number. Please give me a valid amount."
                        end
                    end
                else
                    puts "Sorry, you are broke. :( You can play for free this round. :)"
                    player.make_bet(0)
                end
            end
        }
    end

    # This method deals the cards to the players at the beginning.
    # The output to the command line can be found in Hand and DealersHand
    def deal_cards
        for i in 1..2 do
            @player_list.each {
                |player|
                player.curr_hand.add_card(@bjdeck.pop)
            }
        end
        if @player_list[@player_list.count - 1].curr_hand.has_blackjack
            @player_list.each {
                |player|
                unless player.is_dealer
                    player.add_money(-player.bet)
                end
            }
            @in_play = false
        end
    end

    # This is where the round is actually played
    def play_round
        if @in_play
            all_lost = false
            split_players = Hash.new
            split_hand_values = []
            dealer_value = 0
            players_win = false
            dealer_win = false
            tie = false
            # This section only runs if Dealer's second card is an Ace
            if (@player_list[@player_list.count - 1].curr_hand.insurance)
                @player_list.each {
                    |player|
                    unless player.is_dealer
                        # I'm not familiar with this idea of insurance, but this was my understanding of it
                        puts "#{player.get_id} would you like insurance: yes or no? This means that you won't lose money if the dealer has blackjack from his first 2 cards."
                        answer = gets.chomp.rstrip.lstrip
                        case answer
                        when 'yes'
                            player.insured
                        else
                            puts "No? Alright then."
                        end
                    end

                }
            end
            # This section iterates through the players list, asking for actions for each player one at a time
            @player_list.each {
                |player|
                # The top part deals with regular players (not the dealer).
                # The else statement below this will deal with when you get to the dealer
                unless player.is_dealer
                    puts "Hello #{player.get_id}."
                    hand = player.curr_hand
                    stay = false
                    while hand.can_hit && (not stay) && (not player.is_split) do

                        # Asks for an action
                        puts "#{player.get_id} currently has:"
                        puts hand.to_s
                        if hand.count == 2 && hand.can_split && (not hand.can_double)
                            puts "Would you like to 'hit', 'stay', 'double', or 'split'?"
                        elsif (not hand.can_double)
                            puts "Would you like to 'hit', 'stay', 'double'?"
                        else
                            puts "Would you like to 'hit' or 'stay'?"
                        end

                        action = gets.chomp.downcase.rstrip.lstrip
                        # retrieves command and strips trailing whitespaces if there is any
                        case action
                        when 'hit'
                            hand.add_card(@bjdeck.pop)
                        when 'stay'
                            puts "Alright. Your total is #{hand.total_value}"
                            stay = true
                        when 'double'
                            unless hand.can_double
                                player.double
                                hand.add_card(@bjdeck.pop)
                                stay = true
                                puts "Alright! Your new total is #{hand.total_value} and your bet has doubled"
                            else
                                puts "Sorry, you can't do this!"
                            end
                        when 'split'
                            # this is the tough case...
                            newHand = player.splithand
                            split_hand_values = split(player, hand, newHand)   # he becomes a separate case alltogether
                            split_players[player] = split_hand_values
                        else
                            puts "Sorry, I didn't quite catch that. Please enter a valid command."
                        end
                        if hand.total_value > 21
                            puts "Bust! Sorry :("
                        end
                    end
                    @player_hand_values << player.curr_hand.total_value

                else
                    # the code between this "else" and "end" deals with the Dealer's hand
                    dealer_value = 0
                    dealer = player
                    # If all players have already lost, no need to do anything with the dealer
                    if @player_hand_values.min > 21
                        puts "All players lost."
                        all_lost = true
                        @player_list.each {
                            |playerI|
                            unless playerI.is_dealer
                                playerI.add_money(-playerI.bet)
                                puts "Player #{playerI.get_id} has a new total of #{playerI.money}."
                            end
                        }
                    # However, if not all players have lost, we start looking at the dealer's hand
                    else
                        puts "Dealer is looking at hand and reveals:"
                        puts player.curr_hand.to_s
                        while player.curr_hand.must_hit && (player.curr_hand.total_value <= 21) do
                            player.curr_hand.add_card(@bjdeck.pop)
                        end
                        total_hand = player.curr_hand.total_value
                        @player_hand_values << total_hand
                        if player.curr_hand.bust
                            players_win = true
                            puts "Bust!"
                        else
                            if @player_hand_values.max == total_hand
                                dealer_value = total_hand
                                @player_hand_values -= [dealer_value]
                                if (@player_hand_values.max < dealer_value) # no one else has this score
                                    dealer_win = true
                                    puts "Dealer wins!"
                                else
                                    tie = true
                                    puts "Tie!"
                                end
                            else
                                puts "Dealer loses!"
                            end
                        end
                    end
                end 
            }

            # This section takes care of if there are players who split
            if (not split_players.empty?)
                split_players.keys.each {
                    |player|
                    hand_values = split_players[player]
                    split_player = hand_values[0]
                    for i in 1..2 do
                        hand_value = hand_values[i].to_i
                        if hand_value == 21
                            split_player.add_money(split_player.bet*1.5)
                        elsif (hand_value > 21) || (hand_value < dealer_value && (not players_win))
                            split_player.add_money(-split_player.bet)
                        else
                            split_player.add_money(split_player.bet)
                        end
                    end
                    puts "Split hand player, #{split_player.get_id}, has a new total of #{split_player.money}."
                    split_player.unsplit
                    split_player.restart_hand
                }
            end

            # This section is just adjusting money amounts after the results are known
            if players_win #dealer busts
                @player_list.each {
                    |player|
                    unless player.is_dealer || (player.curr_hand.count == 0)
                        hand_value = player.curr_hand.total_value
                        if hand_value == 21
                            player.add_money(1.5*player.bet)
                        elsif hand_value > 21
                            player.add_money(-player.bet)
                        else
                            player.add_money(player.bet)
                        end
                        puts "Player #{player.get_id} has a new total of #{player.money}."
                    end
                }
            elsif dealer_win    #dealer has highest
                @player_list.each {
                    |playerX|
                    unless playerX.is_dealer || (playerX.curr_hand.count == 0)
                        if (playerX.insured) && (dealer_value == 21) && (dealer.get_hand.count == 2)
                            playerX.insured
                        else
                            playerX.add_money(-playerX.bet)
                            puts "Player #{playerX.get_id} has a new total of #{playerX.money}."
                        end
                    end
                }
            elsif (not all_lost) #if dealer doesn't bust, any score higher than dealer's wins
                @player_list.each {
                    |playerY|
                    unless playerY.is_dealer || (playerY.curr_hand.count == 0)
                        hand_value = playerY.curr_hand.total_value
                        if hand_value == 21
                            playerY.add_money(1.5*playerY.bet)
                        elsif hand_value > 21 || hand_value < dealer_value
                            playerY.add_money(-playerY.bet)
                        else
                            playerY.add_money(playerY.bet)
                        end
                        puts "Player #{playerY.get_id} has a new total of #{playerY.money}."
                    end
                }
            end

            # Asks if player wants to continue with the same people
            puts "Round end. Continue? Reply 'yes' to continue with same players, else thank you for playing!"
            if gets.chomp.downcase == 'yes'
                @in_play = true
                self.reset
            else
                @in_play = false
            end
        end
    end

    # This method resets the game with the same players
    def reset
        @player_list.each {
            |player|
            player.restart_hand
        }
    end

    # This method handles split cases for playesr who choose that option
    def split(player, hand, newhand)
        hand_1 = true
        stay = false
        hand_values = [player]
        hand.add_card(@bjdeck.pop)
        newhand.add_card(@bjdeck.pop)
        puts "Player #{player.get_id} currently has a hand of:"
        puts hand.to_s
        puts "Player also has a second hand of:"
        puts newhand.to_s
        curr_hand = hand
        puts "Let's handle hand 1"
        for i in 1..2 do
            while curr_hand.can_hit && (not stay) do
                if (not curr_hand.can_double)
                    puts "Would you like to 'hit', 'stay', 'double'?"
                else
                    puts "Would you like to 'hit' or 'stay'?"
                end

                action = gets.chomp.downcase.rstrip.lstrip # strips trailing whitespaces
                case action
                when 'hit'
                    curr_hand.add_card(@bjdeck.pop)
                when 'stay'
                    puts "Alright. Your total is #{hand.total_value}"
                    stay = true
                when 'double'
                    unless (curr_hand.can_double)
                        curr_hand.double
                        curr_hand.add_card(@bjdeck.pop)
                        stay = true
                    else
                        puts "Sorry, you can't do this!"
                    end
                else
                    puts "Sorry, I didn't quite catch that. Please enter a valid command."
                end
                if curr_hand.total_value > 21
                    puts "Bust! Sorry :("
                end
            end
            hand_values << curr_hand.total_value
            if hand_1
                puts "Now for hand 2"
                curr_hand = newhand
                stay = false
                puts curr_hand.to_s
                hand_1 = false
            end
        end
        return hand_values
    end

end
