require 'net/http'
require 'uri'

module V1
    module Api
      class SleeperController < ApplicationController
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
        # POST /v1/api/sleeper/username
        def username
          # Validate Username passed
          unless sleeper_user = params[:username]
            return render json: { error: "no-username", message: "Internal Server Error (nu)" }, status: :not_found
          end
          # Find or Create User
          user = User.find_or_create_by(import: :sleeper, username: sleeper_user)
          # Build Sleeper data
          user.sleeper_build
          user.sleeper_build_leagues
          # Update Session Data
          $session.username  = sleeper_user
          $session.key       = :sleeper_username_flow
          $session.user_id   = user.id
          $session.save
          # Validate if user found
          unless user.sleeper_id
            return render json: { error: "no-sleeper-user", message: "Username not found 🤔" }, status: :not_found
          end
          # Render response
          # render json: user.username_api_response
          render json:        {
            status:     "success",
            sessionID:  $session,
            username:   user.username,
            leagues:    user.leagues.select_league,
            email:      "-",
            phone:      "-",
            verified:   false,
            leagueSelected: user.leagues.select_league.pop,
          }
        ensure
          $session = nil
        end
    end
  end
end
  