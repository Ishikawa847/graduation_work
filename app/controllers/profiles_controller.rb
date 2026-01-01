class ProfilesController < ApplicationController
  # プロフィール表示
  def show
    @user = current_user
    @recipes = current_user.recipes
  end

  # プロフィール編集画面
  def edit
    @user = current_user
  end

  # プロフィール更新
  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, success: "プロフィールを更新しました"
    else
      flash.now[:danger] = "プロフィールの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :height,
      :weight,
      :age,
      :gender
    )
  end
end
