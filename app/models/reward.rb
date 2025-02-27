require 'net/http'
require 'uri'
require 'json'

class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :league, optional: true

  def generate_image(prompt="")
    if prompt.empty? || prompt.nil?
        prompt = "watercolor of a professional NFL player celebrating a touchdown in the end zone of a professional football stadium"
    end

    uri = URI.parse("https://api.openai.com/v1/images/generations")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer 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"
    request.body = JSON.dump({
        "model": "dall-e-3",
        "prompt": prompt,
        "n": 1,
        "size": "1024x1024"
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code == "200"
      image_url = JSON.parse(response.body)["data"].first["url"]
        if nft_image.nil?
            self.nft_image_history = []
            self.nft_image = image_url
            self.save
        else
            self.nft_image_history = [] if self.nft_image_history.nil?
            self.nft_image_history.push(self.nft_image)
            self.nft_image = image_url
            self.save
        end
    else
      nil
    end
  end
end


class CreateRewards < ActiveRecord::Migration[6.1]
    def change
      create_table :rewards do |t|
        t.decimal :amount_ucsd, index: true
        t.string :name,         index: true
        t.integer :user_id,     index: true
        t.integer :league_id,   index: true
        t.string :season,       index: true
        t.string :nft_image
        t.json :nft_image_history
  
        t.timestamps
      end
    end
  end
  