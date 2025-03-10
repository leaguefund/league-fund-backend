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
        @user.save
        @user_wallet = "0xWallet"
        # Clean up leagues
        League.where(sleeper_id: @sleeper_champs_league_id).destroy_all
        # Init League Data
        @league_name = "Champions League"
        @league_address = "0xLeague"
        @league_dues_ucsd = 10
        # Init Season
        @season = "2024"
        # Init Session
        @session = Session.find_or_create_by(session_id: @session_id)
        @session.user_id = @user.id
        @session.save
      end

    describe "POST /v1/api/league/created" do
        let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
        it "validates email (ok)" do
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(League, :count).by(1)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/created (address and dues saves)" do
        let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
        it "validates email (ok)" do
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(League, :count).by(1)
          league = @user.leagues.find_by(sleeper_id: @sleeper_champs_league_id)
          # Expect League to conatin dues and address
          expect(league.address).to eq(@league_address)
          expect(league.dues_ucsd).to eq(@league_dues_ucsd)
        end
      end

    describe "POST /v1/api/league/created (additonal users created)" do
        let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
        it "validates email (ok)" do
          # Find Users that belong to league
          expect {
            post "/v1/api/league/created", params: valid_attributes
          }.to change(User, :count).by(11)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/created (session link)" do
      let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
      it "validates email (ok)" do
        expect {
          post "/v1/api/league/created", params: valid_attributes
        }.to change(League, :count).by(1)
        league = @user.leagues.find_by(sleeper_id: @sleeper_champs_league_id)
        # Expect League to be linked to session
        expect(league.id).to eq(@session.reload.league_id)
      end
    end

    describe "POST /v1/api/league/created (league created earlier)" do
      # Create params
      let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
      it "validates email (ok)" do
        # Create League (happens during sleeper/usernamr)
        league      = League.find_or_create_by(sleeper_id: @sleeper_champs_league_id)
        league.name = @league_name
        league.save
        # Create a season
        @user.seasons.find_or_create_by(season: @season, league_id: league.id)
        # Make API call
        expect {
          post "/v1/api/league/created", params: valid_attributes
        }.to change(League, :count).by(0)
        # Expect League to populated (after earlier creation)
        expect(league.reload.address).to eq(@league_address)
        expect(league.reload.dues_ucsd).to eq(@league_dues_ucsd)
      end
    end

    describe "POST /v1/api/league/created (wallet saved to user)" do
      # Create params
      let(:valid_attributes) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
      it "validates email (ok)" do
        expect {
          post "/v1/api/league/created", params: valid_attributes
        }.to change(League, :count).by(1)
        # Expect League to populated (after earlier creation)
        expect(@user.reload.wallet).to eq(@user_wallet)
      end
    end

    describe "POST /v1/api/league/invite" do
        let(:valid_attributes) { { emails: ["alex@gmail.com", "shannon@gmail.com"], league_address: @league_address, session_id: @session.session_id } }

        it "validates email (ok)" do
          League.find_or_create_by(address: @league_address)
          expect {
            post "/v1/api/league/invite", params: valid_attributes
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/read" do
        let(:valid_attributes_created) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
        let(:valid_attributes_read) { { league_address: @league_address, session_id: @session.session_id } }
        it "validates email (ok)" do
          # Create League First
          expect {
            post "/v1/api/league/created", params: valid_attributes_created
          }.to change(League, :count).by(1)
          expect(response).to have_http_status(:ok)
          # Read League
          expect {
            post "/v1/api/league/read", params: valid_attributes_read
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
        end
      end

    describe "POST /v1/api/league/read (returns multiple users)" do
        let(:valid_attributes_created) { { league_sleeper_id: @sleeper_champs_league_id, league_address: @league_address, league_dues_usdc: @league_dues_ucsd, wallet_address: @user_wallet, session_id: @session.session_id } }
        let(:valid_attributes_read) { { league_address: @league_address, session_id: @session.session_id } }
        it "validates email (ok)" do
          # Create League First
          expect {
            post "/v1/api/league/created", params: valid_attributes_created
          }.to change(League, :count).by(1)
          expect(response).to have_http_status(:ok)
          # Read League
          expect {
            post "/v1/api/league/read", params: valid_attributes_read
          }.to change(User, :count).by(0)
          expect(response).to have_http_status(:ok)
          # Pull team ount
          teams_count = JSON.parse(response.body)["teams"].length rescue 0
          # Expect to have at least 1 league
          expect((teams_count > 1)).to be_truthy
        end
      end
end
