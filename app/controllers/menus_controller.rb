class MenusController < ApplicationController

  def new
    @menu = current_user.menus.build
    3.times { @menu.menu_recipes.build }
    @recipes = Recipe.all
  end
  
  def create
    @menu = current_user.menus.build(menu_params)
    
    if @menu.save
      redirect_to "#", success: 'メニューを作成しました'
    else
      @recipes = Recipe.all
      flash.now[:danger] = 'メニューの作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def menu_params
    params.require(:menu).permit(
      :name,
      menu_recipes_attributes: [:id, :recipe_id, :position, :_destroy]
    )
  end
end