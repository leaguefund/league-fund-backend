class League < ApplicationRecord
    has_many :rewards
    has_many :seasons
    # has_many :users, through: :seasons

    after_save :save_downcase_address

    def save_downcase_address
        # Validate address changed
        return nil unless saved_change_to_address?
        # Save downcase address
        update(address_downcase: self.address.to_s.downcase)
    end

    def users
        user_ids = seasons.pluck(:user_id)
        User.where(id: user_ids)
    end

    def latest_season
        season = season.last.try(:season)
    end

    def latest_season_users
        season.last.users
    end

    def puts_sleeper_apis
        puts "="*20
        puts "Sleeper APIs for #{name}"
        puts "-"*20
        puts self.sleeper_avatar_api
        puts self.sleeper_fetch_users
        puts "="*20
    end

    def self.select_league
        all.map do |league|
            {
                id:         league.id,
                name:       league.name,
                avatar:     league.avatar,
                address:    league.address,
                sleeper_id: league.sleeper_id
            }
        end
    end

    def select_team
        latest_season_key = seasons.last.try(:season)
        latest_seasons_connections = seasons.where(season: latest_season_key)

        teams = latest_seasons_connections.map do |season_team|
            {
                username: season_team.user.try(:username),
                avatar: season_team.user.try(:avatar),
                wallet: season_team.user.try(:wallet),
                team_name: season_team.try(:team_name),
                is_commissioner: season_team.try(:is_commissioner),
                is_owner: season_team.try(:is_owner)
            }
        end
        # Return League Data
        return {
            league_name: name,
            league_avatar: avatar,
            league_dues_ucsd: dues_ucsd,
            teams: teams,
        }
    end

    def sleeper_build_users(season_s="2024")
        # Validate username passed 
        return nil if sleeper_id.nil? || sleeper_id.empty? 
        # Make call to sleeper user API
        url = sleeper_fetch_users
        api_call = ApiCall.create(url: url)
        response = Net::HTTP.get_response(URI.parse(url))
        # Successful response
        if response.is_a?(Net::HTTPSuccess)
            # Process the response body as needed
            data = response.body
            api_call.update(notes: data)
            # For example, parse JSON data
            parsed_data = JSON.parse(data)
            # Update API Call
            api_call.update(notes: parsed_data)
            self.update(users_payload: data)
            # Find or Create users (from League Teams) 
            parsed_data.each do |team|
                # Create User based on Sleeper ID
                user = User.find_or_create_by(sleeper_id: team["user_id"])
                user.avatar = team["metadata"]["avatar"] rescue nil
                user.sleeper_avatar_id = team["avatar"]
                user.username = team["display_name"]
                user.save
                # Create seasonal connection
                season = self.seasons.find_or_create_by(season: season_s, user_id: user.id)
                # Save Season Data
                season.team_name = team["team_name"]
                season.is_commissioner = true if (user.id == self.commissioner_id)
                season.is_owner = team["is_owner"]
                season.is_bot = team["is_bot"]
                season.save
            end
            # Display parsed data
            Rails.logger.info(parsed_data)
        else
            # Handle the error response
            Rails.logger.error("HTTP Request failed: #{response.message}")
            return {}
        end
    end
    
    def sleeper_avatar_api
        "https://sleepercdn.com/avatars/thumbs/#{sleeper_avatar_id}" rescue "https://sleepercdn.com/avatars/thumbs/<sleeper_avatar_id>"
    end
    
    def sleeper_fetch_users
        "https://api.sleeper.app/v1/league/#{sleeper_id}/users" rescue "https://api.sleeper.app/v1/league/<league_id>/users"
    end
end
