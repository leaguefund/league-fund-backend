class League < ApplicationRecord
    has_many :rewards
    has_many :seasons
    has_many :users, through: :seasons

    def self.select_league
        all.map do |league|
            {
                id:         league.id,
                name:       league.name,
                avatar:     league.avatar,
                address:    league.address
            }
        end
    end

    def select_team
        # Generate teams

        # Return teams
    end
    
    def sleeper_avatar_api
        "https://sleepercdn.com/avatars/thumbs/#{sleeper_avatar_id}" rescue "https://sleepercdn.com/avatars/thumbs/<sleeper_avatar_id>"
    end
end
