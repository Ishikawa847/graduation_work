class Admin::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.admin?
      sign_in(resource_name, resource)
      redirect_to admin_root_path, notice: "管理者としてログインしました"
    else
      sign_out(resource)
      redirect_to admin_login_path, alert: "管理者ではありません"
    end
  end

  def destroy
    sign_out(resource_name)
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
