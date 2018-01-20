class Casino < ActiveRecord::Base
  has_many :acquisitions
  has_many :dice_games, through: :acquisitions
  has_many :card_games, through: :acquisitions
  has_many :betting_games, through: :acquisitions
end

class CardGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions
end

class BettingGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions
end

class DiceGame < ActiveRecord::Base
  has_many :acquisitions, as: :game
  has_many :casinos, through: :acquisitions
end

class Acquisition < ActiveRecord::Base
  belongs_to :game, polymorphic: true
  belongs_to :casino
end
