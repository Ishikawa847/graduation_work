class DailyMenusController < ApplicationController
  def new
    @daily_menu = DailyMenu.new
    @menus = current_user.menus
  end

  def create
    @daily_menu = current_user.daily_menus.build(daily_menu_params)

    if @daily_menu.save
      redirect_to calendar_path, notice: "献立を登録しました"
    else
      @menus = current_user.menus
      render :new, status: :unprocessable_entity
    end
  end

  private

  def daily_menu_params
    params.require(:daily_menu).permit(:menu_id, :date)
  end
end
