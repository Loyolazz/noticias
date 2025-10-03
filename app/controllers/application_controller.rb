class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_locale
  before_action :ensure_not_banned
  helper_method :current_user, :logged_in?

  private

  def set_locale
    locale = params[:locale]&.to_sym
    locale ||= current_user&.locale&.to_sym if logged_in?
    I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to new_session_path, alert: t('flash.must_login')
  end

  def require_admin
    require_login
    return if performed?
    return if current_user&.admin?

    redirect_to root_path, alert: t('flash.admin_only')
  end

  def ensure_not_banned
    return unless current_user&.banned?

    reset_session
    redirect_to root_path, alert: t('flash.banned')
  end
end
