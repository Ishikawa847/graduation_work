class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.like(@recipe)
    
    render json: { 
      liked: true, 
      likes_count: @recipe.likes.count 
    }
  end
  
  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    current_user.unlike(@recipe)
    
    render json: { 
      liked: false, 
      likes_count: @recipe.likes.count 
    }
  end
end