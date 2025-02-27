require 'rails_helper'

RSpec.describe "Leagues", type: :request do
    
    before(:all) do
        @user = User.find_or_create_by(import: :sleeper, username: "alexmcritchie")
        @session = Session.find_or_create_by(session_id: "123-456")
        @session.user_id = @user.id
        @session.save
      end

    describe "POST /v1/api/league/created" do
        let(:valid_attributes) { { league_id: "123", league_address: "0x123", league_dues_usdc: 10, session_id: @session.session_id } }
        it "validates email (ok)" do
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/invite" do
        let(:league) { League.find_or_create_by(address: "0x123") }
        let(:valid_attributes) { { emails: ["alex@gmail.com", "shannon@gmail.com"], league_address: league.address, session_id: @session.session_id } }

        it "validates email (ok)" do
          expect {
            post "/v1/api/league/invite", params: valid_attributes
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/read" do
        let(:league) { League.find_or_create_by(address: "0x123") }
        let(:valid_attributes) { { league_address: league.address, session_id: @session.session_id } }

        it "validates email (ok)" do
          expect {
            post "/v1/api/league/read", params: valid_attributes
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end
end
