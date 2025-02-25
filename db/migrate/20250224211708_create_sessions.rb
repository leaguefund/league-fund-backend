class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.string :key
      t.string :session_id
      t.string :username
      t.integer :user_id
      t.integer :league_id
      t.string :email
      t.string :wallet
      t.json :data

      t.timestamps
    end
  end
end
