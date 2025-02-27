class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :avatar
      t.string :address,          index: true
      t.string :sleeper_id,       index: true
      t.integer :commissioner_id, index: true
      t.string :sleeper_avatar_id,index: true
      
      t.json :invites
      t.json :seasons

      t.timestamps
    end
  end
end
