require 'rails_helper'

RSpec.describe "Rewards", type: :request do
  before(:all) do
    @user = User.find_or_create_by(import: :sleeper, username: "alexmcritchie", wallet: "0xWallet")
    @session = Session.find_or_create_by(session_id: "123-456")
    @session.user_id = @user.id
    @session.save
    @league = League.find_or_create_by(address: "0xLeague")
  end

  describe "POST /v1/api/reward/created" do
    let(:valid_attributes) { { name: "Reward Name", amount_ucsd: 100, reciever_wallet: "0xWallet", league_address: "0xLeague", session_id: @session.session_id } }

    it "creates a reward (ok)" do
      expect {
        post "/v1/api/reward/created", params: valid_attributes
      }.to change(Reward, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /v1/api/reward/read" do
    let(:reward) { Reward.create(name: "Reward Name", amount_ucsd: 100, user_id: @user.id, league_id: 1) }
    let(:valid_attributes) { { reward_id: reward.id, session_id: @session.session_id } }

    it "reads a reward (ok)" do
      get "/v1/api/reward/read", params: valid_attributes
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["reward"]["id"]).to eq(reward.id)
    end
  end

  describe "POST /v1/api/reward/image" do
    let(:reward) { Reward.create(name: "Reward Name", amount_ucsd: 100, user_id: @user.id, league_id: 1) }
    let(:valid_attributes) { { reward_id: reward.id, session_id: @session.session_id } }

    it "generates an image for the reward (ok)" do
      post "/v1/api/reward/image", params: valid_attributes
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["reward"]["id"]).to eq(reward.id)
      puts JSON.parse(response.body)
    end
  end
end
