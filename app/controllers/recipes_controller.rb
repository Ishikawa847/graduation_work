class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user)
  end

  def new
    @recipe = current_user.recipes.build
    # 材料入力用のフォームを3つ準備
    3.times do
      recipe_ingredient = @recipe.recipe_ingredients.build
      recipe_ingredient.build_ingredient
    end
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

  private

  def recipe_params
    params.require(:recipe).permit(
      :name, :description, :image,
      recipe_ingredients_attributes: [
        :id,
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