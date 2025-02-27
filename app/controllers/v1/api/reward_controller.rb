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
        end

        def created
            # Validate Winner Username passed
            unless winner_username = params[:winner_username]
                return render json: { error: "no-winner-username", message: "Internal Server Error (nwu)" }, status: :not_found
            end
            # Validate Name passed
            unless reward_name = params[:reward_name]
                return render json: { error: "no-reward-name", message: "Internal Server Error (nrn)" }, status: :not_found
            end
            # Validate USDC passed
            unless reward_amount_ucsd = params[:amount_ucsd]
                return render json: { error: "no-reward-usdc", message: "Internal Server Error (nru)" }, status: :not_found
            end
            # Find Winner
            winner = $league.users.find_by(username: winner_username)
            # Not saving wallet earlier
            winner.wallet = $winner_wallet if winner.wallet.nil?
            winner.save 
            # Find or create reward
            reward = winner.rewards.find_or_create_by(league_id: $league.id, amount_ucsd: reward_amount_ucsd, name: reward_name, season: "2024")
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
        end

        def read
            # Find Winner
            winner = $league.users.find_by(wallet: $winner_wallet)
            # Grab rewards (could be many)
            rewards = $league.rewards.where(user_id: winner.id)
            rewards_view = rewards.mint_reward_view
            first_reward = rewards_view.pop
            # Return Reward
            render json: { status: "success", message: "Reward created successfully", reward: first_reward, other_wallet_rewards: rewards_view }, status: :ok
        ensure
            $session = nil  
            $league = nil 
            $winner_wallet = nil     
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
        end
    end
  end
end
