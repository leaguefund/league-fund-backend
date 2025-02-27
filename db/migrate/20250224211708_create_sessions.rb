class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.string :key
      t.string :session_id, index: true
      t.string :username,   index: true
      t.integer :user_id,   index: true
      t.integer :league_id, index: true
      t.string :email,      index: true
      t.string :wallet,     index: true
      t.json :data

      t.timestamps
    end
  end
end
