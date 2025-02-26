require 'net/http'
require 'uri'

module V1
    module Api
      class SleeperController < ApplicationController
        skip_before_filter :verify_authenticity_token
        # POST /v1/api/sleeper/username
        def username
          # Validate Session and Username passed
          unless session_id = params[:session_id]
            return render json: { error: "no-session-id", message: "Internal Server Error (nsi)" }, status: :not_found
          end
          unless sleeper_user = params[:username]
            return render json: { error: "no-username", message: "Internal Server Error (nu)" }, status: :not_found
          end
          # Find or Create User
          user = User.find_or_create_by(import: :sleeper, username: sleeper_user)
          # Find or Create Session
          session = Session.find_or_create_by(session_id: session_id)
          session.username  = sleeper_user
          session.key       = :sleeper_username
          session.user_id   = user.id
          session.save
          # Setup user and session
          user.build_sleeper_user
          # Validate if user found
          unless user.sleeper_id
            return render json: { error: "no-sleeper-user", message: "Username not found 🤔" }, status: :not_found
          end
          # Render response
          render json: user.username_api_response
        end
  
        # # GET /v1/api/league/read
        # def read
        #   # For this example, assume a league id is passed as a query parameter.
        #   league = League.find_by(id: params[:league_id])
        #   if league
        #     render json: league
        #   else
        #     render json: { error: "League not found" }, status: :not_found
        #   end
        # end
      end
    end
  end
  