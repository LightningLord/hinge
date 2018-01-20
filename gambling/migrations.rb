class CreateCasinosAndGames < ActiveRecord::Migration
  def change
    create_table :casinos do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.timestamps
    end

    create_table :card_games do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.string :variant_name, default: 'standard'
      t.integer :deck_size, default: 52, null: false
      t.boolean :rigged, default: false, null: false
      t.timestamps
    end

    create_table :betting_games do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.integer :classification, null: false, default: 0
      t.integer :legality, null: false, default: 0
      t.integer :max_bettors
      t.decimal :projected_gain
      t.timestamps
    end

    create_table :dice_games do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.integer :num_dice, null: false
      t.timestamps
    end

    create_table :acquisitions do |t|
      t.string :game_type, null: false
      t.integer :game_id, null: false
      t.integer :casino_id, null: false
      t.decimal :income_generated
      t.timestamps
    end
  end
end
