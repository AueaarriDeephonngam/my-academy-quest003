require 'rails_helper'

RSpec.describe "Quests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/quests/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/quests/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /toggle" do
    it "returns http success" do
      get "/quests/toggle"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/quests/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
