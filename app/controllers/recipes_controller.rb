class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user)
  end

  def new
    @recipe = current_user.recipes.build
    # 材料入力用のフォームを3つ
    3.times { @recipe.recipe_ingredients.build }
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    
    if @recipe.save
      redirect_to @recipe, notice: 'レシピが投稿されました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :name, :description, :image,
      recipe_ingredients_attributes: [:id, :ingredient_id, :quantity, :_destroy,
    :ingredient_name, :protein_per_100g, :fat_per_100g, :carbohydrate_per_100g
  ]
    )
  end
end
