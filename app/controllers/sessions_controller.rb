class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    credentials = session_params
    @user = User.find_by(email: credentials[:email])

    if @user&.authenticate(credentials[:password])
      if @user.banned?
        redirect_to new_session_path, alert: t('flash.banned')
      else
        session[:user_id] = @user.id
        redirect_to root_path, notice: t('flash.signed_in')
      end
    else
      flash.now[:alert] = t('flash.invalid_credentials')
      @user = User.new(email: credentials[:email])
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: t('flash.signed_out')
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
