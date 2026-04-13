class CalendarsController < ApplicationController
  def index
  @start_date = params[:start_date]&.to_date || Date.current
  @daily_menus = current_user.daily_menus
  end

  def week
    @start_date = params[:start_date]&.to_date || Date.today
    @week_dates = (@start_date.beginning_of_week..@start_date.end_of_week).to_a

    @daily_menus = DailyMenu
      .includes(:menu)
      .where(date: @week_dates.first.beginning_of_day..@week_dates.last.end_of_day)
    
    # group_byで日付ごとにまとめてハッシュ化
    @daily_menus_by_date = @daily_menus.group_by(&:date)

    @pfc = DailyMenu.total_pfc(@daily_menus)
  end
end
