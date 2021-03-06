require 'pry'

require 'minitest/autorun'
require 'minitest/pride'
require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

class TurnTest < Minitest::Test
  def setup
    @card1 = Card.new(:heart, 'Queen', 12)
    @card2 = Card.new(:diamond, '3', 3)
    @card3 = Card.new(:spade, 'King', 13)
    @card4 = Card.new(:heart, '8', 8)
    @card5 = Card.new(:club, 'Jack', 11)
    @card6 = Card.new(:diamond, '5', 5)
    @card7 = Card.new(:heart, 'King', 13)
    @card8 = Card.new(:club, '3', 3)
    @basic_deck1 = Deck.new([@card1, @card2, @card3])
    @basic_deck2 = Deck.new([@card4, @card5, @card6])
    @war_deck1 = Deck.new([@card3, @card2, @card4, @card5])
    @war_deck2 = Deck.new([@card7, @card1, @card6, @card8])
    @mad_deck1 = Deck.new([@card3, @card1, @card2, @card5])
    @mad_deck2 = Deck.new([@card7, @card4, @card8, @card6])
    @player1 = Player.new('Ryan', @basic_deck1)
    @player2 = Player.new('Tim', @basic_deck2)
    @basic_turn = Turn.new(@player1, @player2)
    @player3 = Player.new('Bob', @war_deck1)
    @player4 = Player.new('Jim', @war_deck2)
    @war_turn = Turn.new(@player3, @player4)
    @player5 = Player.new('Ryan', @mad_deck1)
    @player6 = Player.new('Tim', @mad_deck2)
    @mad_turn = Turn.new(@player5, @player6)
  end

  def test_it_exists
    assert_instance_of Turn, @basic_turn
  end

  def test_it_has_a_player_1_attribute
    assert_equal @player1, @basic_turn.player1
  end

  def test_it_has_a_player_2_attribute
    assert_equal @player2, @basic_turn.player2
  end

  def test_it_has_a_spoils_of_war_attribute_that_defaults_to_an_empty_array
    assert_equal [], @basic_turn.spoils_of_war
  end

  def test_it_has_a_type
    assert_equal :basic, @basic_turn.type
  end

  def test_the_type_is_basic_if_the_first_cards_in_each_players_decks_are_different
    assert_equal :basic, @basic_turn.type
  end

  def test_the_type_is_war_if_the_first_cards_in_each_players_decks_are_equal
    assert_equal :war, @war_turn.type
  end

  def test_the_type_is_mutually_assured_desctruction_if_the_
    assert_equal :mutually_assured_destruction, @mad_turn.type
  end

  def test_it_has_a_winner
    assert_equal 'Ryan', @basic_turn.winner.name
    assert_equal 'Bob', @war_turn.winner.name
  end

  def test_there_is_NOT_a_winner_if_the_type_is_mutually_assured_destruction
    assert_equal "No Winner", @mad_turn.winner
  end

  def test_pile_cards_sends_each_players_top_card_to_spoils_during_a_basic_turn
    @basic_turn.pile_cards()

    assert_equal [@card1, @card4], @basic_turn.spoils_of_war
    assert_equal [@card2, @card3], @basic_turn.player1.deck.cards
    assert_equal [@card5, @card6], @basic_turn.player2.deck.cards
  end

  def test_pile_cards_sends_each_players_top_three_cards_to_spoils_during_a_war_turn
    @war_turn.pile_cards()

    assert_equal [@card3, @card2, @card4, @card7, @card1, @card6], @war_turn.spoils_of_war
    assert_equal [@card5], @war_turn.player1.deck.cards
    assert_equal [@card8], @war_turn.player2.deck.cards
  end

  def test_pile_cards_deletes_each_players_top_three_cards_during_a_mad_turn_w_no_spoils
    @mad_turn.pile_cards

    assert_equal [], @mad_turn.spoils_of_war
    assert_equal [@card5], @mad_turn.player1.deck.cards
    assert_equal [@card6], @mad_turn.player2.deck.cards
  end

  def test_award_spoils
    @basic_turn.pile_cards
    @basic_turn.award_spoils(@player1)
    assert_equal [@card2, @card3, @card1, @card4], @player1.deck.cards
  end
end
