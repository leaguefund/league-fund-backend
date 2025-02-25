class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :import
      t.string :username
      t.string :email
      t.string :avatar
      t.string :wallet
      t.string :sleeper_id
      t.string :sleeper_avatar_id
      t.json :favorite_league
      t.json :leagues_cache
      t.json :data

      t.timestamps
    end
  end
end
