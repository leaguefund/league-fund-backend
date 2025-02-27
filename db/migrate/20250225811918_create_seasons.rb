class CreateSeasons < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons do |t|
      t.decimal :dues_ucsd,       index: true
      t.string :season,           index: true
      t.string :team_name,        index: true
      t.string :team_avatar,      index: true
      t.integer :user_id,         index: true
      t.integer :league_id,       index: true
      t.boolean :is_commissioner, index: true
      t.boolean :is_owner,        index: true
      t.boolean :is_bot,          index: true
      t.json :data

      t.timestamps
    end
  end
end
