module V1
    module Api
      class LeagueController < ApplicationController
        skip_before_filter :verify_authenticity_token
        # POST /v1/api/league/invite
        def invite
          # For example, assume we receive a league id and an invite payload.
          league = League.find_by(id: params[:league_id])
          unless league
            render json: { error: "League not found" }, status: :not_found and return
          end
  
          # Example logic: Append an invite to the league's invites JSON array.
          # (You might need to initialize it as an array if nil.)
          invites = league.invites || []
          invites << params[:invite] if params[:invite]
          league.update(invites: invites)
  
          render json: { message: "Invite added successfully", league: league }
        end
  
        # GET /v1/api/league/read
        def read
          # For this example, assume a league id is passed as a query parameter.
          league = League.find_by(id: params[:league_id])
          if league
            render json: league
          else
            render json: { error: "League not found" }, status: :not_found
          end
        end
      end
    end
  end
  