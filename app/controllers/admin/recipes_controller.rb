class Admin::RecipesController < Admin::BaseController
  before_action :set_recipe, only: %i[edit update destroy]

  def index
    @recipes = Recipe.includes(:user).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new

    3.times do
      recipe_ingredient = @recipe.recipe_ingredients.build
      recipe_ingredient.build_ingredient
    end

    @ingredients = Ingredient.all
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to admin_recipes_path, notice: "レシピを作成しました"
    else
      build_ingredients_if_needed
      @ingredients = Ingredient.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ingredients = Ingredient.all
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to admin_recipes_path, notice: "レシピを更新しました"
    else
      @ingredients = Ingredient.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy!
    redirect_to admin_recipes_path, notice: "レシピを削除しました"
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def build_ingredients_if_needed
    while @recipe.recipe_ingredients.size < 3
      @recipe.recipe_ingredients.build.build_ingredient
    end
  end

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
          :carb,
          :calories
        ]
      ]
    )
  end
end