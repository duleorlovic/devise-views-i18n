class SignUpsController < ApplicationController
  def create
    if User.where(email: _sign_up_company_form_params[:email]).present?
      redirect_to new_user_session_path, alert: 'You are already registered. Try to log in'
      return
    end
    @sign_up_company_form = SignUpCompanyForm.new _sign_up_company_form_params
    if @sign_up_company_form.save
      if @sign_up_company_form.user.confirmed?
        sign_in @sign_up_company_form.user
      else
        flash[:notice] = t('devise.registrations.signed_up_but_unconfirmed')
      end
      redirect_to root_path
    else
      flash.now[:alert] = @sign_up_company_form.errors.full_messages.to_sentence
      render 'pages/home'
    end
  end

  def _sign_up_company_form_params
    params.require(:sign_up_company_form).permit(*SignUpCompanyForm::FIELDS)
  end
end
