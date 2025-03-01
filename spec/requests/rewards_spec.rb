require 'rails_helper'

RSpec.describe "Rewards", type: :request do

  before(:all) do
    User.where(wallet: "0xWallet").destroy_all
    League.where(address: "0xLeague").destroy_all
    # Init Session
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
    @league.address = "0xLeague"
    @league.dues_ucsd = 10
    @league.save
    # Init Season
    @season = "2024"
    # Create seasonal connection
    @user.seasons.find_or_create_by(season: @season, league_id: @league.id)
    # Find or create reward
    @league.rewards.destroy_all
    # Init Session
    @session = Session.find_or_create_by(session_id: @session_id)
    @session.user_id = @user.id
    @session.league_id = @league.id
    @session.save
    # Reward Details
    @reward_name =  "Reward Name"
    @reward_amount_usdc =  100
    @winner_wallet =  "0xWallet"
    @league_address =  "0xLeague"
  end

  describe "POST /v1/api/reward/created" do
    let(:valid_attributes) { { reward_name: @reward_name, amount_ucsd: @reward_amount_usdc, winner_wallet: @winner_wallet, league_address: @league_address, session_id: @session.session_id } }
    it "creates a reward (ok)" do
      expect {
        post "/v1/api/reward/created", params: valid_attributes
      }.to change(Reward, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /v1/api/reward/created (wallet & league saved)" do
    let(:valid_attributes) { { reward_name: @reward_name, amount_ucsd: @reward_amount_usdc, winner_wallet: @winner_wallet, league_address: @league_address, session_id: @session.session_id } }
    it "creates a reward (ok)" do
      expect {
        post "/v1/api/reward/created", params: valid_attributes
      }.to change(Reward, :count).by(1)
      expect(response).to have_http_status(:ok)
      # Fetch reward
      reward = Reward.find_by_id(JSON.parse(response.body)["reward"]["id"])
      # Validate wallet & league address saved
      expect(reward.winner_wallet).to eq(@winner_wallet)
      expect(reward.league_address).to eq(@league_address)
    end
  end

  describe "POST /v1/api/reward/created (user.id & league.id saved)" do
    let(:valid_attributes) { { reward_name: @reward_name, amount_ucsd: @reward_amount_usdc, winner_wallet: @winner_wallet, league_address: @league_address, session_id: @session.session_id } }
    it "creates a reward (ok)" do
      expect {
        post "/v1/api/reward/created", params: valid_attributes
      }.to change(Reward, :count).by(1)
      expect(response).to have_http_status(:ok)
      # Fetch reward
      reward = Reward.find_by_id(JSON.parse(response.body)["reward"]["id"])
      # Validate wallet & league address saved
      expect(reward.league_id).to eq(@league.id)
      expect(reward.user_id).to eq(@user.id)
    end
  end

  describe "POST /v1/api/reward/read" do
    let(:valid_attributes) { { reward_name: @reward_name, winner_wallet: @winner_wallet, league_address: @league_address, session_id: @session.session_id } }
    it "reads a reward (ok)" do
      # Create Reward
      reward = @league.rewards.find_or_create_by(name: @reward_name, winner_wallet: @winner_wallet, league_address: @league_address, amount_ucsd: @reward_amount_usdc, user_id: @user.id)
      post "/v1/api/reward/read", params: valid_attributes
      expect(response).to have_http_status(:ok)
      puts "JSON.parse(response.body)"
      puts JSON.parse(response.body)
      puts "JSON.parse(response.body)"
      expect(JSON.parse(response.body)["reward"]["web_2_id"]).to eq(reward.id)
    end
  end

  describe "POST /v1/api/reward/image" do
    it "generates an image for the reward (ok)" do
      # Create Reward
      reward = @league.rewards.find_or_create_by(name: @reward_name, winner_wallet: @winner_wallet, league_address: @league_address, amount_ucsd: @reward_amount_usdc, user_id: @user.id)
      first_nft_image = reward.nft_image
      valid_attributes = {reward_web_2_id: reward.id, session_id: @session.session_id }
      post "/v1/api/reward/image", params: valid_attributes
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "POST /v1/api/reward/image (image changed)" do
    it "generates an image for the reward (ok)" do
      # Create Reward
      reward = @league.rewards.find_or_create_by(name: @reward_name, winner_wallet: @winner_wallet, league_address: @league_address, amount_ucsd: @reward_amount_usdc, user_id: @user.id)
      first_nft_image = reward.nft_image
      valid_attributes = {reward_web_2_id: reward.id, session_id: @session.session_id }
      post "/v1/api/reward/image", params: valid_attributes
      expect(response).to have_http_status(:ok)
      expect(first_nft_image).not_to eq(reward.reload.nft_image)
    end
  end
end
