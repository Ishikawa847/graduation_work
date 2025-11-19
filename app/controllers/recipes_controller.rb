class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:user)
  end
end
