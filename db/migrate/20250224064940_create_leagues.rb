class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :address
      t.string :name
      t.string :avatar
      t.integer :commissioner_id
      t.string :sleeper_id
      t.string :sleeper_avatar_id
      
      t.json :invites

      t.timestamps
    end
  end
end
