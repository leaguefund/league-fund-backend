class User < ApplicationRecord

    has_many :sessions
    has_many :seasons
    has_many :rewards
    # has_many :leagues, through: :seasons

    after_save :save_downcase_wallet

    def save_downcase_wallet
        # Validate wallet_changed
        return nil unless saved_change_to_wallet
        # Save downcase wallet
        update(wallet_downcase: self.wallet.to_s.downcase)
    end

    def leagues
        league_ids = seasons.pluck(:league_id)
        League.where(id: league_ids)
    end

    def puts_sleeper_apis
        puts "="*20
        puts "Sleeper APIs for #{username}"
        puts "-"*20
        puts self.sleeper_user_api
        puts self.sleeper_avatar_api
        puts self.sleeper_league_api
        puts "="*20
    end

    def sleeper_build
        # Validate username passed 
        return nil if username.nil? || username.empty? 
        # Make call to sleeper user API
        response = Net::HTTP.get_response(URI.parse(sleeper_user_api))
        # Return nil if not successful
        return nil unless response.is_a?(Net::HTTPSuccess)
        # Process the response body as needed
        data = response.body
        # For example, parse JSON data
        parsed_data = JSON.parse(data)
        # Return nil if no username found.
        return nil if parsed_data.nil?
        # Save Sleeper data
        self.sleeper_id = parsed_data["user_id"]
        self.sleeper_avatar_id = parsed_data["avatar"]
        self.save
    end

    def sleeper_build_avatar
        # Validate username passed 
        return nil if sleeper_avatar_id.nil? || sleeper_avatar_id.empty? 
        # Create avatart URL
        avatar_url = sleeper_avatar_api
        self.avatar = avatar_url
        self.save
    end

    def sleeper_build_leagues(season="2024")
        # Validate username passed 
        return nil if sleeper_id.nil? || sleeper_id.empty? 
        # Make call to sleeper user API
        url = sleeper_league_api(season)
        api_call = ApiCall.create(url: url)
        response = Net::HTTP.get_response(URI.parse(url))
        # Successful response
        if response.is_a?(Net::HTTPSuccess)
            # Process the response body as needed
            data = response.body
            api_call.update(notes: data)
            # For example, parse JSON data
            parsed_data = JSON.parse(data)
            api_call.update(notes: parsed_data)
            self.update(leagues_cache: parsed_data)
            # Display parsed data
            Rails.logger.info(parsed_data)
            # Create Leagues for user
            parsed_data.each do |sleeper_league|
                # Skip non-NFL leagues
                next unless sleeper_league["sport"] == "nfl"
                # Find or create sleeper league
                league = League.find_or_create_by(sleeper_id: sleeper_league["league_id"])
                league.name                 = sleeper_league["name"]
                league.sleeper_avatar_id    = sleeper_league["avatar"]
                league.avatar               = league.sleeper_avatar_api
                league.save
                # Create seasonal connection
                self.seasons.find_or_create_by(season: season, league_id: league.id)
            end
        else
            # Handle the error response
            Rails.logger.error("HTTP Request failed: #{response.message}")
            return 'sleeper-error'
        end
    end

    def sleeper_user_api
        "https://api.sleeper.app/v1/user/#{username}" rescue "https://api.sleeper.app/v1/user/<username>"
    end
    def sleeper_avatar_api
        "https://sleepercdn.com/avatars/thumbs/#{sleeper_avatar_id}" rescue "https://sleepercdn.com/avatars/thumbs/<sleeper_avatar_id>"
    end
    def sleeper_league_api(season="2024")
        "https://api.sleeper.app/v1/user/#{sleeper_id}/leagues/nfl/#{season}" rescue "https://api.sleeper.app/v1/user/<sleeper_id>/leagues/nfl/2024"
    end

    def league_response
        res = []
        res.push({
            "name":"Work League",
            "logo":"https://preview.redd.it/random-logos-not-tied-to-anything-just-having-fun-making-v0-zaodc1g3gdrc1.png?width=640&crop=smart&auto=webp&s=4c0e2c89187c6c76ded7189457a2ec0588667928",
            "teams":10,
            "started":2024
         })
        # Each through cache
        leagues_cache.each do |league|
            res.push({
                name: league["league_name"],
                logo: league["league_avatar"],
                teams: 99,
                started: 2030
            })
        end
        res.push({
            "name":"College Friends",
            "logo":"https://www.figma.com/community/resource/d3ce5064-a3ee-468b-8245-0e47504800f2/thumbnail",
            "teams":12,
            "started":2016
         })
        # Return res
        return res
    end

    def username_api_response
        {
          status: "success",
          sessionID:"73ef1145-2e7f-4426-a108-9cccd376f61d",
          username: username,
          leagues: league_response,
          email: "-",
          phone: "-",
          verified: false,
          leagueSelected: league_response.pop,
        }
    end


    {
   "status": "success",
   "sessionID":"73ef1145-2e7f-4426-a108-9cccd376f61d",
   "username":"alexmcritchie",
   "leagues":[
      {
         "name":"College Friends",
         "logo":"https://www.figma.com/community/resource/d3ce5064-a3ee-468b-8245-0e47504800f2/thumbnail",
         "teams":12,
         "started":2016
      },
      {
         "name":"Champions League",
         "logo":"https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/7a3ec529632909.55fc107b84b8c.png",
         "teams":12,
         "started":2024
      },
      {
         "name":"Work League",
         "logo":"https://preview.redd.it/random-logos-not-tied-to-anything-just-having-fun-making-v0-zaodc1g3gdrc1.png?width=640&crop=smart&auto=webp&s=4c0e2c89187c6c76ded7189457a2ec0588667928",
         "teams":10,
         "started":2024
      }
   ],
   "email":"amcritchie@gmail.com",
   "phone":"",
   "verified":true,
   "leagueSelected":{
      "name":"Champions League",
      "logo":"https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/7a3ec529632909.55fc107b84b8c.png",
      "teams":12,
      "started":2024
   }
}

            #   t.string :import
        #   t.string :username
        #   t.string :email
        #   t.string :avatar
        #   t.string :wallet
        #   t.string :sleeper_id
        #   t.string :sleeper_avatar_id
        #   t.json :favorite_league
        #   t.json :leagues_cache
        #   t.json :data
        # puts "parsed_data"
        # puts parsed_data
        # puts "parsed_data"
        # https://api.sleeper.app/v1/user/alexmcritchie
        # https://api.sleeper.app/v1/user/1130233530270801920/leagues/nfl/2024
        # https://api.sleeper.app/v1/league/1129868530242949120
        # https://api.sleeper.app/v1/league/1129868530242949120/users
end

# class YourModel < ApplicationRecord
#   def fetch_data
#     url = URI.parse('http://www.example.com/resource')
#     response = Net::HTTP.get_response(url)
#     if response.is_a?(Net::HTTPSuccess)
#       # Process the response body as needed
#       data = response.body
#       # For example, parse JSON data
#       parsed_data = JSON.parse(data)
#       # Use the parsed data within your model
#     else
#       # Handle the error response
#       Rails.logger.error("HTTP Request failed: #{response.message}")
#     end
#   end
# end
