class ApplicationController < ActionController::Base
  around_action :_set_locale_from_session

  def _set_locale_from_session
    locale = current_user&.locale ||
             _extract_locale_from_http_accept_language_and_set_to_session
    if locale.present?
      I18n.with_locale locale.to_sym do
        yield
      end
    else
      yield
    end
  end

  def _extract_locale_from_http_accept_language_and_set_to_session
    return session[:locale] if session[:locale].present?

    locale = request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
    session[:locale] = locale if locale.present? && I18n.available_locales.include?(locale.to_sym)
  end

  # rubocop:disable Metrics/AbcSize
  def set_locale
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_s.to_sym)
      session[:locale] = params[:locale]
      if current_user.present? && current_user.locale != params[:locale]
        current_user.locale = params[:locale]
        current_user.save!
        flash[:notice] = t('data_item_name_successfully_changed', item_name: User.human_attribute_name(:locale))
      end
    end
    redirect_to root_path
  end
  # rubocop:enable Metrics/AbcSize
end
