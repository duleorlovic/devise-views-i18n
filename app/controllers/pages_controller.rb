class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[
    notify_javascript_error
  ]

  def home
    @search_happenings = SearchHappenings.new
  end

  def sign_in_development
    return unless Rails.env.development? || Rails.application.secrets.is_staging || current_user&.superadmin?

    user = User.find params[:id]
    sign_in :user, user, byepass: true
    redirect_to params[:redirect_to] || root_path
  end

  def contact
    @contact = Contact.new(
      email: current_user&.email
    )
  end

  def submit_contact
    @contact = Contact.new(
      email: current_user&.email || params[:contact][:email],
      text: params[:contact][:text],
      g_recaptcha_response: params['g-recaptcha-response'],
      current_user: current_user,
      remote_ip: request.remote_ip,
    )
    if @contact.save
      redirect_to contact_path, notice: t('contact_thanks')
    else
      flash.now[:alert] = @contact.errors.full_messages.join(', ')
      render :contact
    end
  end

  def sample_error
    raise 'This is sample_error on server'
  end

  def sample_error_in_javascript
    render layout: true, html: %(
      Calling manual_js_error_now
      <script>
        function manual_js_error_now_function() {
          manual_js_error_now
        }
        console.log('calling manual_js_error_now');
        manual_js_error_now_function();
        // you can also trigger error on window.onload = function() { manual_js_error_onload }
      </script>
      <br>
      <button onclick="trigger_js_error_on_click">Trigger error on click</button>
      <a href="/sample-error-in-javascript-ajax" data-remote="true" id="l">Trigger error in ajax</a>
    ).html_safe
  end

  def sample_error_in_javascript_ajax
    render js: %(
      console.log("starting sample_error_in_javascript_ajax");
      sample_error_in_javascript_ajax
    )
  end

  def notify_javascript_error
    js_receivers = Rails.application.secrets.javascript_error_recipients
    if js_receivers.present?
      ExceptionNotifier.notify_exception(
        Exception.new(params[:errorMsg]),
        env: request.env,
        exception_recipients: js_receivers.to_s.split(','),
        data: {
          current_user: current_user,
          params: params
        }
      )
    end
    head :ok
  end

  def sample_error_in_sidekiq
    TaskWithErrorJob.perform_later
    render plain: 'TaskWithErrorJob in queue, please run: bundle exec sidekiq -C config/sidekiq.yml'
  end
end
