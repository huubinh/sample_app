class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale =
      I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("login_required")
    redirect_to login_url
  end
end
