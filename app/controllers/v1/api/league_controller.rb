module V1
    module Api
      class LeagueController < ApplicationController
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

        # POST /v1/api/league/created
        def created
          # Validate League passed
          unless league_id = params[:league_id]
            return render json: { error: "no-league-id", message: "Internal Server Error (nli)" }, status: :not_found
          end
          # Validate League Address passed
          unless league_address = params[:league_address]
            return render json: { error: "no-league-address", message: "Internal Server Error (nla)" }, status: :not_found
          end
          # Validate Wallet Address passed
          unless wallet_address = params[:wallet_address]
            return render json: { error: "no-wallet-address", message: "Internal Server Error (nwa)" }, status: :not_found
          end
          # Validate League Dues passed
          unless league_dues_usdc = params[:league_dues_usdc]
            return render json: { error: "no-league-dues", message: "Internal Server Error (nld)" }, status: :not_found
          end
          # Find or create League based on sleeper_id + commissioner
          league                  = League.find_or_create_by(id: params[:league_id], commissioner_id: $session.user_id)
          league.address          = league_address
          league.dues_ucsd        = league_dues_usdc
          league.save

          Rails.logger.info("--------1")
          Rails.logger.info(params[:wallet_address])
          Rails.logger.info("--------2")
          Rails.logger.info($session.inspect)
          Rails.logger.info("--------3")
          Rails.logger.info($session.user.inspect)
          Rails.logger.info("--------4")
          # Save 
          $session.user.update(wallet: wallet_address)

          Rails.logger.info($session.user.errors.inspect)

          # Fetch additional users
          league.sleeper_build_users

          # Update Session Data
          $session.league_id = league.id
          $session.save
          # Logic for league creation
          render json: { status: "success", message: "League created successfully" }, status: :ok
        ensure
          $session = nil
        end
    
        # POST /v1/api/league/invite
        def invite
          # Validate League Address passed
          unless league_address = params[:league_address]
            return render json: { error: "no-league-address", message: "Internal Server Error (nla)" }, status: :not_found
          end
          # Validate League Address passed
          unless league = League.find_by(address: league_address)
            return render json: { error: "no-league-found", message: "Internal Server Error (nlf)" }, status: :not_found
          end
          # Validate Emails passed
          unless emails = params[:emails]
            return render json: { error: "no-emails-passed", message: "Internal Server Error (nep)" }, status: :not_found
          end

          # Send League Emails!
  
          render json: { status: "success", message: "Invite added successfully", league: league }
        ensure
          $session = nil
        end
  
        # GET /v1/api/league/read
        def read
          # Validate League Address passed
          unless league_address = params[:league_address]
            return render json: { error: "no-league-address", message: "Internal Server Error (nla)" }, status: :not_found
          end
          # Validate League Address passed
          unless league = League.find_by(address: league_address)
            return render json: { error: "no-league-found", message: "Internal Server Error (nlf)" }, status: :not_found
          end

          render json: { 
            status: "success", 
            league_id: league.id,
            name: league.name,
            avatar: league.avatar,
            league_sleeper_id: league.sleeper_id,
            teams: league.select_team,
            dues_ucsd: league.dues_ucsd
          }

        ensure
          $session = nil
        end
      end
    end
  end