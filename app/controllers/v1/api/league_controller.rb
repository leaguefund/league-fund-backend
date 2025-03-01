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
          unless league_sleeper_id = params[:league_sleeper_id]
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
          Rails.logger.info("=======")
          Rails.logger.info(league_address)
          Rails.logger.info(league_sleeper_id)
          Rails.logger.info($session.user_id)
          Rails.logger.info("-------")
          # Claim sleeper league with no commissioner or create new
          unless league = League.where(sleeper_id: league_sleeper_id, commissioner_id: nil).last
            league = League.find_or_create_by(sleeper_id: league_sleeper_id, commissioner_id: $session.user_id)
          end

          Rails.logger.info("-------")
          Rails.logger.info(league.inspect)
          Rails.logger.info("=======")
          # A Sleeper League may have multiple leagues but only one per commissioner
          league.address          = league_address
          league.dues_ucsd        = league_dues_usdc
          league.save

          Rails.logger.info("-------")
          Rails.logger.info(league.errors.inspect)
          Rails.logger.info("=======")
          # Save user's wallet address
          $session.user.update(wallet: wallet_address)
          # Fetch additional users
          league.sleeper_build_users
          league.puts_sleeper_apis
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
          unless league = League.find_by(address_downcase: league_address.to_s.downcase)
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
          unless league = League.find_by(address_downcase: league_address.to_s.downcase)
            return render json: { error: "no-league-found", message: "Internal Server Error (nlf)" }, status: :not_found
          end
          # Return JSON
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