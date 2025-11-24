class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user)
  end

  def new
    @recipe = current_user.recipes.build
    # 材料入力用のフォームを3つ
    3.times do
    recipe_ingredient = @recipe.recipe_ingredients.build
    recipe_ingredient.build_ingredient  # ★これが重要！
    end
  end

def create
  puts "\n=== 受信パラメータの詳細 ==="
  puts "全params: #{params.inspect}"
  
  puts "\n=== recipeパラメータの構造 ==="
  if params[:recipe]
    puts "recipe params: #{params[:recipe].inspect}"
    
    if params[:recipe][:recipe_ingredients_attributes]
      puts "\n=== recipe_ingredients_attributes の詳細 ==="
      params[:recipe][:recipe_ingredients_attributes].each do |key, value|
        puts "#{key}: #{value.inspect}"
        if value[:ingredient_attributes]
          puts "  ingredient_attributes: #{value[:ingredient_attributes].inspect}"
        end
      end
    else
      puts "recipe_ingredients_attributes が存在しません"
    end
  else
    puts "recipeパラメータが存在しません"
  end
  
  puts "\n=== recipe_params（変換後） ==="
  converted_params = recipe_params
  puts converted_params.inspect
  
  @recipe = current_user.recipes.build(converted_params)
  
  puts "\n=== 保存前のrecipe_ingredients数 ==="
  puts @recipe.recipe_ingredients.size
  
  # 既存のコードを継続...
  if @recipe.save
    puts "\n=== 保存後の確認 ==="
    @recipe.reload
    puts "recipe_ingredients数: #{@recipe.recipe_ingredients.count}"
    puts "ingredients数: #{@recipe.ingredients.count}"
    
    redirect_to recipes_path, notice: 'レシピが作成されました'
  else
    puts "\n=== 保存エラー ==="
    puts "Recipe errors: #{@recipe.errors.full_messages}"
    @recipe.recipe_ingredients.each_with_index do |ri, index|
      puts "RecipeIngredient #{index} エラー: #{ri.errors.full_messages}"
      if ri.ingredient
        puts "Ingredient #{index} エラー: #{ri.ingredient.errors.full_messages}"
        puts "Ingredient #{index} 属性: name=#{ri.ingredient.name}, protein=#{ri.ingredient.protein}, fat=#{ri.ingredient.fat}, carb=#{ri.ingredient.carb}"
      end
    end
    
    # エラー時にフォーム用データを再準備
    while @recipe.recipe_ingredients.size < 3
      @recipe.recipe_ingredients.build.build_ingredient
    end
    render :new
  end
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
