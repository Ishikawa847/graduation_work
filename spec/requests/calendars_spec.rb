require 'rails_helper'

RSpec.describe "Calendars", type: :request do
  describe "GET /calendar/week" do
    it "週間カレンダーが表示される" do
      get "/calendar/week"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("week")
    end
  end
end
