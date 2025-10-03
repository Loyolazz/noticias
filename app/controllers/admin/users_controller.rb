module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[ban unban]

    def index
      @users = User.order(:name)
    end

    def ban
      @user.update!(banned: true)
      redirect_back fallback_location: admin_users_path, notice: t('flash.user_banned')
    end

    def unban
      @user.update!(banned: false)
      redirect_back fallback_location: admin_users_path, notice: t('flash.user_unbanned')
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
