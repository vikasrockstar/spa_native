require 'rails_helper'

RSpec.describe "QrCodes", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/qrcodes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/qrcodes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/qrcodes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/qrcodes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
