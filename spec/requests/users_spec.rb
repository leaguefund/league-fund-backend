require 'rails_helper'

RSpec.describe "Users API", type: :request do

  describe "POST /v1/api/sleeper/username" do
    let(:valid_attributes) { { username: "alexmcritchie", session_id: "123-456" } }
    it "creates a user (ok)" do
      post "/v1/api/sleeper/username", params: valid_attributes
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /v1/api/sleeper/username (no-sleeper-user)" do
    let(:valid_attributes) { { username: "qqqqwwwwxxxxpoiu", session_id: "123-456" } }
    it "creates a user (not_found)" do
      post "/v1/api/sleeper/username", params: valid_attributes
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /v1/api/user/email" do
    session = Session.find_or_create_by(session_id: "123-456")
    user = User.find_or_create_by(import: :sleeper, username: "alexmcritchie")
    let(:valid_attributes) { { email: "alex@leaguefund.xyz", session_id: "123-456" } }
    it "saves email (ok)" do
      expect {
        post "/v1/api/user/email", params: valid_attributes
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /v1/api/user/validate-email" do
    let(:valid_attributes) { { email: "alex@leaguefund.xyz", token: "123-456" } }
    it "validates email (ok)" do
      expect {
        post "/v1/api/user/validate-email", params: valid_attributes
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(:ok)
    end
  end
end
