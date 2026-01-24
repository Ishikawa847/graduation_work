class RecipesController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

  def autocomplete
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result(distinct: true).limit(10)

    render json: @recipes.map { |recipe| 
      { 
        id: recipe.id, 
        name: recipe.name,
        description: recipe.description&.truncate(100) # 説明文を100文字に制限
      } 
    }
  end

  def new
        Rails.logger.debug "current_user: #{current_user.inspect}"
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
    redirect_to recipes_path, notice: "レシピが作成されました"
  else
    # エラー時にフォーム用データを再準備
    while @recipe.recipe_ingredients.size < 3
      @recipe.recipe_ingredients.build.build_ingredient
    end
    @ingredients = Ingredient.all
    render :new, status: :unprocessable_entity
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
      redirect_to recipe_path(@recipe), notice: "レシピを編集しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy!
    redirect_to recipes_path, notice: "レシピを削除しました。"
  end

  def search_nutrition
    food_name = params[:food_name]
    
    if food_name.blank?
      render json: { error: '食材名を入力してください' }, status: :bad_request
      return
    end

    service = GeminiService.new
    result = service.get_pfc_values(food_name)

    if result
      render json: {
        name: result[:name],
        protein: result[:protein],
        fat: result[:fat],
        carb: result[:carb],
        calories: result[:calories]
      }
    else
      render json: { error: '食材情報の取得に失敗しました' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Gemini API Error: #{e.message}")
    render json: { error: 'サーバーエラーが発生しました' }, status: :internal_server_error
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
