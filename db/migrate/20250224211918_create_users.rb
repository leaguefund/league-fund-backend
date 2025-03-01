class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :import,           index: true
      t.string :username,         index: true
      t.string :email,            index: true
      t.string :avatar
      t.string :wallet,           index: true
      t.string :wallet_downcase,  index: true
      t.string :sleeper_id,       index: true
      t.string :sleeper_avatar_id,index: true
      t.json :seasons
      t.json :favorite_league
      t.json :leagues_cache
      t.json :data

      t.string :email_token,      index: true
      t.timestamp :email_verification_sent_at

      t.timestamps
    end
  end
end
