class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.decimal :amount_ucsd,   index: true
      t.string :name,           index: true
      t.integer :user_id,       index: true
      t.integer :league_id,     index: true
      t.string :winner_wallet,  index: true
      t.string :league_address, index: true
      t.string :league_address_downcase, index: true
      t.string :season,         index: true
      t.string :nft_image
      t.json :nft_image_history

      t.timestamps
    end
  end
end
