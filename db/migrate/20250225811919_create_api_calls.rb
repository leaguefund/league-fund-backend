class CreateApiCalls < ActiveRecord::Migration[6.1]
  def change
    create_table :api_calls do |t|
      t.string :url,         index: true
      t.string :summary,     index: true
      t.json :response
      t.json :notes

      t.timestamps
    end
  end
end
