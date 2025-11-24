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
  puts "=== 受信パラメータ ==="
  puts params.inspect
  puts "\n=== recipe_params ==="
  puts recipe_params.inspect
  
  @recipe = current_user.recipes.build(recipe_params)
  
  puts "\n=== 保存前のrecipe_ingredients数 ==="
  puts @recipe.recipe_ingredients.size
  
  @recipe.recipe_ingredients.each_with_index do |ri, index|
    puts "#{index}: 分量=#{ri.quantity}, 材料名=#{ri.ingredient&.name}"
  end
  
  if @recipe.save
    puts "\n=== 保存後の確認 ==="
    @recipe.reload
    puts "recipe_ingredients数: #{@recipe.recipe_ingredients.count}"
    puts "ingredients数: #{@recipe.ingredients.count}"
    
    redirect_to recipes_path, notice: 'レシピが作成されました'
  else
    puts "\n=== 保存エラー ==="
    puts @recipe.errors.full_messages
    @recipe.recipe_ingredients.each_with_index do |ri, index|
      puts "RecipeIngredient #{index} エラー: #{ri.errors.full_messages}"
      puts "Ingredient #{index} エラー: #{ri.ingredient&.errors&.full_messages}"
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
        ingredient: [
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
