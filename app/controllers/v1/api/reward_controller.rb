module V1
  module Api
    class RewardController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :identify_session, except:[:image]

        def identify_session
            # Validate Session and Username passed
            unless session_id = params[:session_id]
                return render json: { error: "no-session-id", message: "Internal Server Error (nsi)" }, status: :not_found
            end
            # Create session variable
            $session = Session.find_or_create_by(session_id: session_id)
            # Validate League Address passed
            unless league_address = params[:league_address]
                return render json: { error: "no-league-address", message: "Internal Server Error (nla)" }, status: :not_found
            end
            # Create league variable
            $league = League.find_by(address: league_address)
            # Validate Winner Wallet passed
            unless $winner_wallet = params[:winner_wallet]
                return render json: { error: "no-winner-wallet", message: "Internal Server Error (nww)" }, status: :not_found
            end
            # Fetch winning user
            $winning_user = User.find_or_create_by(wallet: $winner_wallet)
        end

        def created
            # Validate Name passed
            unless reward_name = params[:reward_name]
                return render json: { error: "no-reward-name", message: "Internal Server Error (nrn)" }, status: :not_found
            end
            # Validate USDC passed
            unless reward_amount_ucsd = params[:amount_ucsd]
                return render json: { error: "no-reward-usdc", message: "Internal Server Error (nru)" }, status: :not_found
            end
            # Set season
            season = params[:season] || "2024"
            # Find or create reward
            reward = $winning_user.rewards.find_or_create_by(league_id: $league.id, amount_ucsd: reward_amount_ucsd, name: reward_name, season: season)

            # Todo, make test as this seemed not to work.
            reward.winner_wallet = $winner_wallet
            reward.league_address = $league.address
            reward.save

            # Generate an initial image for minting
            reward.generate_image
            # Logic for league creation
            render json: { status: "success", message: "Reward created successfully", reward: reward }, status: :ok
        ensure
          $session = nil
          $league = nil  
          $winner_wallet = nil 
          $winning_user = nil     
        end

        def read
            # Find Winner
            # winner = $league.users.find_by(wallet: $winner_wallet)
            # # Grab rewards (could be many)
            # rewards = $league.rewards.where(user_id: winner.id)
            # rewards = $league.rewards.where(user_id: winner.id)
            Rails.logger.info("-------1")
            Rails.logger.info(params[:winner_wallet])
            Rails.logger.info(params[:league_address])
            Rails.logger.info($winner_wallet.inspect)
            Rails.logger.info($winning_user.inspect)
            Rails.logger.info($league.inspect)
            Rails.logger.info($league.address)
            Rails.logger.info("-------2")
            Rails.logger.info(Reward.all.inspect)
            Rails.logger.info("-------3")
            Rails.logger.info($winning_user.rewards.inspect)
            Rails.logger.info("-------4")
            # Find rewards for user in a specific league
            rewards = $winning_user.rewards.where(league_address: $league.address)
            # Fetch rewards
            rewards_view = rewards.mint_reward_view
            first_reward = rewards_view.pop
            # Return Reward
            render json: { status: "success", message: "Reward created successfully", reward: first_reward, other_wallet_rewards: rewards_view }, status: :ok
        ensure
            $session = nil  
            $league = nil 
            $winner_wallet = nil  
            $winning_user = nil   
        end

        def image
            # Validate Session and Username passed
            unless session_id = params[:session_id]
                return render json: { error: "no-session-id", message: "Internal Server Error (nsi)" }, status: :not_found
            end
            # Create session variable
            $session = Session.find_or_create_by(session_id: session_id)
            # Validate Reward ID passed
            unless reward_id = params[:reward_web_2_id]
                return render json: { error: "no-reward-id", message: "Internal Server Error (nri)" }, status: :not_found
            end
            # Validate Reward ID passed
            unless reward = Reward.find_by_id(params[:reward_web_2_id])
                return render json: { error: "no-reward-found", message: "Internal Server Error (nrf)" }, status: :not_found
            end
            # Generate new image 
            prompt = params[:prompt]
            if prompt.nil? || prompt.to_s.empty?
                reward.generate_image
            else
                reward.generate_image(prompt)
            end
            # Return Reward
            render json: { status: "success", message: "Reward created successfully", reward: reward.reward_view }, status: :ok
        ensure
            $session = nil
            $league = nil  
            $winner_wallet = nil 
            $winning_user = nil     
        end
    end
  end
end
