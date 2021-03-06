class Player
  attr_reader :name, :deck

  def initialize(name, deck)
    @deck = deck
    @name = name
  end

  def has_lost?
    @deck.cards.length == 0
  end
end
