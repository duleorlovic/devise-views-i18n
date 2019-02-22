class ApplicationController < ActionController::Base
  around_action :_set_locale_from_session

  def _set_locale_from_session
    locale = current_user&.locale
    locale ||= session[:locale]
    if locale.present?
      I18n.with_locale locale.to_sym do
        yield
      end
    else
      yield
    end
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
