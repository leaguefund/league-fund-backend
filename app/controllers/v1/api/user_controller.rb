module V1
    module Api
      class UserController < ApplicationController
        skip_before_action :verify_authenticity_token
        # POST /v1/api/user/email
        def email
          # Validate Session and Username passed
          unless session_id = params[:session_id]
            return render json: { error: "no-session-id", message: "Internal Server Error (nsi)" }, status: :not_found
          end
          unless email = params[:email]
            return render json: { error: "no-email", message: "Internal Server Error (ne)" }, status: :not_found
          end
          # Find or Create Session
          session = Session.find_or_create_by(session_id: session_id)
          # Fetch user
          user = session.user
          user.email = email

          # Send verification email
          # user.send_verification_email
          # t.string :email_token,      index: true
          # t.timestamp :email_verification_sent_at

          render json: { status: "success", message: "Email Sent" }
        end
  
        # POST /v1/api/user/validate_email
        def validate_email
          # Validate Email and Token passed
          unless email = params[:email]
            return render json: { error: "no-email-passed", message: "Internal Server Error (nep)" }, status: :not_found
          end
          unless token = params[:token]
            return render json: { error: "no-token", message: "Internal Server Error (nt)" }, status: :not_found
          end

          # Mark email as validated 
          # Validate token
          
          render json: { status: "success", message: "Email Validated" }
        end
      end
    end
  end


