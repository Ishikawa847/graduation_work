class MenusController < ApplicationController
  def index
    @menus = current_user.menus.includes(:menu_recipes, :recipes).order(created_at: :desc)
  end

  def new
    @menu = current_user.menus.build
    3.times { @menu.menu_recipes.build }
    @recipes = Recipe.all
  end

  def create
    @menu = current_user.menus.build(menu_params)

    if @menu.save
      redirect_to menus_path, success: "メニューを作成しました"
    else
      @recipes = Recipe.all
      flash.now[:danger] = "メニューの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @menu = current_user.menus.find(params[:id])
  end

  def edit
    @menu = current_user.menus.find(params[:id])
    (3 - @menu.menu_recipes.size).times { @menu.menu_recipes.build } if @menu.menu_recipes.size < 3
    @recipes = Recipe.all
  end

  def update
    @menu = current_user.menus.find(params[:id])
   if @menu.update(menu_params)
      redirect_to menu_path(@menu), notice: "献立を編集しました"
   else
      render :edit, status: :unprocessable_entity
   end
  end

  def destroy
    menu = current_user.menus.find(params[:id])
    menu.destroy!
    redirect_to menus_path, notice: "献立を削除しました。"
  end

  private

  def menu_params
    params.require(:menu).permit(
      :name,
      menu_recipes_attributes: [ :id, :recipe_id, :position, :_destroy ]
    )
  end
end
