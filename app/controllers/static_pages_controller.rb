class StaticPagesController < ApplicationController
  def top
    if user_signed_in?
      # ログイン済みの場合はレシピ一覧にリダイレクト
      redirect_to recipes_path
    else
      # ログイン前の場合はランディングページを表示
      render "static_pages/top"
    end
  end

  def terms
  end

  def privacy
  end
end
