module V1
  module Api
    class RewardController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :identify_session

        def identify_session
            # Validate Session and Username passed
            unless session_id = params[:session_id]
                return render json: { error: "no-session-id", message: "Internal Server Error (nsi)" }, status: :not_found
            end
            # Create session variable
            $session = Session.find_or_create_by(session_id: session_id)
        end

        def created
          # Validate Name passed
          unless name = params[:name]
            return render json: { error: "no-reward-name", message: "Internal Server Error (nrn)" }, status: :not_found
          end
          # Validate USDC passed
          unless amount_ucsd = params[:amount_ucsd]
            return render json: { error: "no-reward-usdc", message: "Internal Server Error (nru)" }, status: :not_found
          end
          # Validate Reciever Wallet passed
          unless reciever_wallet = params[:reciever_wallet]
            return render json: { error: "no-reciever-wallet", message: "Internal Server Error (nrw)" }, status: :not_found
          end
          # Validate League Address passed
          unless league_address = params[:league_address]
            return render json: { error: "no-league-address", message: "Internal Server Error (nla)" }, status: :not_found
          end
            #   Find Winner
            winner = User.find_by(wallet: reciever_wallet)
            #   Find League
            league = League.find_by(address: league_address)
            # Create Reward Record
            reward = Reward.find_or_create_by(league_id: league.id, user_id: winner.id, name: name)
            reward.amount_ucsd = amount_ucsd
            reward.save
          # Logic for league creation
          render json: { status: "success", message: "Reward created successfully" }, status: :ok
        ensure
          $session = nil        
        end

        def read
             # Validate Session and Username passed
             unless reward_id = params[:reward_id]
                return render json: { error: "no-reward-id", message: "Internal Server Error (nri)" }, status: :not_found
            end
            # Validate Reward Foubd passed
            unless reward = Reward.find_by(id: reward_id)
                return render json: { error: "no-reward-found", message: "Internal Server Error (nrf)" }, status: :not_found
            end
            # 
            reward = Reward.find_by(id: reward_id)
            # Logic for handling reward image

            # Return Reward
            render json: { status: "success", message: "Reward created successfully", reward: reward }, status: :ok
        ensure
            $session = nil        
        end

        def image
            # Validate Session and Username passed
            unless reward_id = params[:reward_id]
                return render json: { error: "no-reward-id", message: "Internal Server Error (nri)" }, status: :not_found
            end
            # Validate Reward Foubd passed
            unless reward = Reward.find_by(id: reward_id)
                return render json: { error: "no-reward-found", message: "Internal Server Error (nrf)" }, status: :not_found
            end
            # 
            reward = Reward.find_by(id: reward_id)
            # Logic for handling reward image

            # Add prompt extra 

            reward.generate_image

            # Return Reward
            render json: { status: "success", message: "Reward created successfully", reward: reward }, status: :ok
        ensure
            $session = nil        
        end
    end
  end
end
