class CalendarsController < ApplicationController
  def index
    @daily_menus = current_user.daily_menus.includes(:menu)
  end
end
