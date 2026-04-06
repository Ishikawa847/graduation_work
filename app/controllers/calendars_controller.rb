class CalendarsController < ApplicationController
  def index
  @start_date = params[:start_date]&.to_date || Date.current
  @daily_menus = current_user.daily_menus
  end

  def week
  end
end
