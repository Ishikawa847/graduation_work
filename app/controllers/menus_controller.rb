class MenusController < ApplicationController

  def new
    @menu = current_user.menus.build
  end
  
  def create
    @menu = current_user.menus.build(menu_params)
    
    if @menu.save
      redirect_to @menu, success: 'メニューを作成しました'
    else
      flash.now[:danger] = 'メニューの作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end
end