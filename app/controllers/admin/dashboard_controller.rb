class Admin::DashboardController < Admin::BaseController
  def index
    @users = User.all
  end
end
