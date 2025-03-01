require 'net/http'
require 'uri'
require 'json'

class Reward < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :league, optional: true

    after_save :save_downcase_league_address

    def save_downcase_league_address
        # Validate league_address changed
        return nil unless saved_change_to_league_address?
        # Save downcase league address
        update(league_address_downcase: self.league_address.to_s.downcase)
    end

    def generate_image(prompt=nil)
        @standard_prompt="watercolor of a professional NFL player celebrating a touchdown in the end zone of a professional football stadium"
        # Replace with standard prompt if non-was passed.
        prompt = @standard_prompt if prompt.nil? || prompt.to_s.empty?
        # Generate new NFT image candidate
        new_image_candidate = dalle_call(prompt)
        # Safe NFT Image to reward record
        if nft_image.nil?
            self.nft_image_history = []
            self.nft_image = new_image_candidate
            self.save
        else
            self.nft_image_history = [] if self.nft_image_history.nil?
            self.nft_image_history.push(self.nft_image)
            self.nft_image = new_image_candidate
            self.save
        end
    end

    def dalle_call(prompt)
        # Return random photo if running in TEST
        return ["https://images.unsplash.com/photo-1592670130429-fa412d400f50", "https://images.unsplash.com/photo-1551336841-32a98a5917eb", "https://images.unsplash.com/photo-1496196614460-48988a57fccf"].sample if Rails.env.test?
        # Create URI for DALLE image generations
        uri = URI.parse("https://api.openai.com/v1/images/generations")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request["Authorization"] = "Bearer #{ENV["OPEN_API_KEY"]}"
        request.body = JSON.dump({
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        })
        # Set SSL
        req_options = {use_ssl: uri.scheme == "https"}
        # Make response to Dall-E
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
        # Return Image 
        JSON.parse(response.body)["data"].first["url"]
    rescue => errors
        puts errors.inspect
        puts errors.backtrace
        # BBB 7472
        "https://res.cloudinary.com/coin-nft/image/upload/q_99,w_329/f_auto/v1/cache/1/42/23/42236f9559e3ecaa723d1d839c4e42aa5f0cdb72080de7c2798ea7930437ce1a-NWVhMWM3ZDAtYzQyZi00OTRkLWFmNWQtZDdjZTk5MzhlYjk3"
    end

    def self.mint_reward_view
        all.map { |reward| reward.reward_view }
    end

    def reward_view
        {
            web_2_id:           self.id,
            name:               self.name,
            amount_ucsd:        self.amount_ucsd,
            season:             self.season,
            nft_image:          self.nft_image,
            nft_image_history:  self.nft_image_history,
            league_name:        self.league.name,
            league_avatar:      self.league.avatar,
            winner_username:    self.user.username,
            winner_wallet:      self.user.wallet,
            winner_avatar:      self.user.avatar
        }
    end
end