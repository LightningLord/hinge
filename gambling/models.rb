class Casino < ActiveRecord::Base
  has_many :acquisitions
  has_many :dice_games, through: :acquisitions
  has_many :card_games, through: :acquisitions
  has_many :betting_games, through: :acquisitions
end

class CardGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions

  TYPE_BLACKJACK = 0
  TYPE_POKER = 1
end

class BettingGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions

  TYPE_HORSE_RACE = 0
  TYPE_ELECTION = 1

  CLASSIFICATION_LOCAL = 0
  CLASSIFICATION_REGIONAL = 1
  CLASSIFICATION_NATIONAL = 2
  CLASSIFICATION_INTERNATIONAL = 3

  LEGALITY_LEGAL = 0
  LEGALITY_ILLEGAL = 1
  LEGALITY_UNCLEAR = 2
end

class DiceGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions

  TYPE_CRAPS = 0
end

class Acquisition < ActiveRecord::Base
  belongs_to :game, polymorphic: true
  belongs_to :casino
end
