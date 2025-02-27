require 'rails_helper'

RSpec.describe "Rewards", type: :request do
  describe "POST /rewards" do
    let(:valid_params) do
      {
        reward: {
          league_address: '0x123',
          name: 'Champion',
          amount_usdc: 100.0,
          wallet: '0xabc',
          season: '2023'
        }
      }
    end

    it "creates a reward and triggers async jobs" do
      expect {
        post rewards_path, params: valid_params
      }.to change(Reward, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns an error with invalid params" do
      post rewards_path, params: { reward: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
