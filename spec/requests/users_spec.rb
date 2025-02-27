require 'rails_helper'

RSpec.describe "Users API", type: :request do

  before(:all) do
    @session_id = SecureRandom.uuid
    @sleeper_username = "alexmcritchie"
    @sleeper_champs_league_id = "1129868530242949120"
    # Destroy User
    User.find_by(username: @sleeper_username).try(:destroy)
    # Destroy Champion's League
    League.find_by(sleeper_id: @sleeper_champs_league_id).try(:destroy)
  end

  describe "POST /v1/api/sleeper/username (no-sleeper-user)" do
    let(:valid_attributes) { { username: "qqqqwwwwxxxxpoiu", session_id: @session_id } }
    it "creates a user (not_found)" do
      post "/v1/api/sleeper/username", params: valid_attributes
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /v1/api/sleeper/username" do
    let(:valid_attributes) { { username: @sleeper_username, session_id: @session_id } }
    it "creates a user (ok)" do
      post "/v1/api/sleeper/username", params: valid_attributes
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /v1/api/sleeper/username (user created)" do
    let(:valid_attributes) { { username: @sleeper_username, session_id: @session_id } }
    it "creates a user (ok)" do
      expect {
        post "/v1/api/sleeper/username", params: valid_attributes
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:ok)
      expect(League.find_by(sleeper_id: @sleeper_champs_league_id)).not_to be_nil
    end
  end

  describe "POST /v1/api/sleeper/username (league created)" do
    let(:valid_attributes) { { username: @sleeper_username, session_id: @session_id } }
    it "creates a user (ok)" do
      expect {
        post "/v1/api/sleeper/username", params: valid_attributes
      }.to change(League, :count).by(1)
      expect(response).to have_http_status(:ok)
      expect(User.find_by(username: @sleeper_username)).not_to be_nil
      
    end
  end

  describe "POST /v1/api/user/email" do
    let(:valid_attributes) { { email: "alex@leaguefund.xyz", session_id: @session_id } }
    it "saves email (ok)" do
      # Find or create user
      user = User.find_or_create_by(import: :sleeper, username: @sleeper_username)
      # Find or  create session
      session = Session.find_or_create_by(session_id: @session_id)
      session.user_id = user.id
      session.save
      expect {
        post "/v1/api/user/email", params: valid_attributes
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /v1/api/user/validate-email" do
    let(:valid_attributes) { { email: "alex@leaguefund.xyz", token: "123-456", session_id: @session_id } }
    it "validates email (ok)" do
      # Find or create user
      user = User.find_or_create_by(import: :sleeper, username: @sleeper_username)
      # Find or  create session
      session = Session.find_or_create_by(session_id: @session_id)
      session.user_id = user.id
      session.save
      expect {
        post "/v1/api/user/validate-email", params: valid_attributes
      }.to change(User, :count).by(0)
      expect(response).to have_http_status(:ok)
    end
  end
end
