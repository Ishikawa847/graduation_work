class Admin::DashboardController < Admin::BaseController
  def index
    @user = User.first
  end
end