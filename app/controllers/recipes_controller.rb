class RecipesController < ApplicationController
  def index
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

  def new
    @recipe = current_user.recipes.build
    # 材料入力用のフォームを3つ準備
    3.times do
      recipe_ingredient = @recipe.recipe_ingredients.build
      recipe_ingredient.build_ingredient
    end
    @ingredients = Ingredient.all
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    
    if @recipe.save
      redirect_to recipes_path, notice: 'レシピが作成されました'
    else
      # エラー時にフォーム用データを再準備
      while @recipe.recipe_ingredients.size < 3
        @recipe.recipe_ingredients.build.build_ingredient
      end
      render :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
    @ingredients = Ingredient.all
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe), notice: 'レシピを編集しました' 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy!
    redirect_to recipes_path, notice: "レシピを削除しました。"
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :name, :description, :image,
      recipe_ingredients_attributes: [
        :id,
        :ingredient_id,
        :quantity,
        :_destroy,
        ingredient_attributes: [
          :id, 
          :name, 
          :protein, 
          :fat, 
          :carb
        ]
      ]
    )
  end
end