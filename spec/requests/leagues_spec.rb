require 'rails_helper'

RSpec.describe "Leagues", type: :request do

      before(:all) do
        @session_id = SecureRandom.uuid
        @sleeper_username = "alexmcritchie"
        @sleeper_user_id = "1130233530270801920"
        @sleeper_champs_league_id = "1129868530242949120"
        # Init User
        @user = User.find_or_create_by(import: :sleeper, username: @sleeper_username)
        @user.sleeper_id = @sleeper_user_id
        @user.wallet = "0xWallet"
        @user.save
        # Init League
        @league = League.find_or_create_by(sleeper_id: @sleeper_champs_league_id)
        @league_address = "0xLeague"
        @league_dues_ucsd = 10
        @league.save
        # Init Season
        @season = "2024"
        # Create seasonal connection
        @user.seasons.find_or_create_by(season: @season, league_id: @league.id)
        # Delete other seasonal connections
        @league.seasons.where.not(user_id: @user.id).destroy_all
        # Init Session
        @session = Session.find_or_create_by(session_id: @session_id)
        @session.user_id = @user.id
        @session.league_id = @league.id
        @session.save
      end

    describe "POST /v1/api/league/created" do
        let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user.wallet, session_id: @session.session_id } }
        it "validates email (ok)" do
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(League, :count).by(1)
          expect(response).to have_http_status(:ok)
        end
      end

    # describe "POST /v1/api/league/created (address and dues saves)" do
    #     let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user.wallet, session_id: @session.session_id } }
    #     it "validates email (ok)" do
    #       expect {
    #         post "/v1/api/league/created", params: valid_attributes
    #       }.to change(League, :count).by(1)

    #       puts "------1"
    #       puts @league.reload.inspect
    #       puts @league_address
    #       puts "------1"
    #       # Expect League to conatin dues and address
    #       expect(@league.reload.address).to eq(@league_address)
    #       expect(@league.dues_ucsd).to eq(@league_dues_ucsd)
    #     end
    #   end
    describe "POST /v1/api/league/created (additonal users created)" do
        let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user.wallet, session_id: @session.session_id } }
        it "validates email (ok)" do
          # Find Users that belong to league
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(User, :count).by(11)
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

    describe "POST /v1/api/league/read" do
        # @league.sleeper_build_users
        let(:valid_attributes) { { league_address: @league.address, session_id: @session.session_id } }

        it "validates email (ok)" do
          @league.address = @league_address
          @league.save
          puts "@league.address"
          puts @league.address
          puts @session.session_id
          puts "@league.address"
          expect {
            post "/v1/api/league/read", params: valid_attributes
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end

    # describe "POST /v1/api/league/read (returns multiple users)" do
    #     let(:valid_attributes) { { league_address: @league.address, session_id: @session.session_id } }
    #     it "validates email (ok)" do
    #       puts "+1.a"
    #       @league.address = @league_address
    #       puts "+1.b"
    #       puts @league_address
    #       puts "+1.b"
    #       @league.save
    #       puts "+1.c"
    #       puts @league.inspect
    #       puts @league.errors.inspect
    #       puts "+1.d"
    #       puts League.last.inspect
    #       puts "+1.e"
    #       # Build additional sleeper users
    #       @league.sleeper_build_users
    #       expect {
    #         post "/v1/api/league/read", params: valid_attributes
    #       }.to change(User, :count).by(0)
    #       expect(response).to have_http_status(:ok)

    #       teams_count = JSON.parse(response.body)["teams"].length rescue 0
    #       # Expect to have at least 1 league
    #       expect((teams_count > 1)).to be_truthy
    #     end
    #   end
end
