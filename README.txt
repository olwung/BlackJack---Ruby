==================================
README
==================================

	To run the game, type the following into the terminal

		'ruby blackjackplay.rb'

	The other files are to be read but not run directly.
	They are classes:

		BlackJackGame.rb
			This class basically contains all information about the game itself.

		Card.rb
			This class contains information about a single card.
			For example, an instance of a card would have information
			about the card's suit, value, and number/symbol

		Deck.rb
			This class was made to generate a deck for the game.

		Hand.rb
			This is a class that contains all information about a players hand.

		DealersHand.rb
			This class inherits from the Hand.rb class and contains information
			regarding the dealer's hand.

		Player.rb
			This class contains all information about the player and what actions
			and states they can be in as well as their money and their bets.

		Dealer.rb
			This class inherits from Player.rb and contains information about
			the dealer. This is a special case because they aren't exactly affected
			much in terms of money since they represent the House/Casino so they
			themselves don't really gain or lost anything. 

	Enjoy! :)