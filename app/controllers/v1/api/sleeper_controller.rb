require 'net/http'
require 'uri'

module V1
    module Api
      class SleeperController < ApplicationController
        # POST /v1/api/sleeper/username
        def username
          # For example, assume we receive a league id and an invite payload.
          session_id = params[:session_id]
          sleeper_user = params[:username]
          # Setup user and session
          user = User.build_sleeper_user(sleeper_user)
          session = Session.find_or_create_by(session_id: session_id)
          session.user_id = user.id
          session.save
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
  