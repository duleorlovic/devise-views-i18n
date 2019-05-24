class Admin::UsersController < Admin::BaseController
  before_action :_set_user, except: %i[index new create]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @user = User.new
    update_and_render_or_redirect_in_js @user, _user_params, ->(id) { admin_user_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @user, _user_params, admin_user_path(@user)
  end

  def destroy
    @user.destroy!
    redirect_to admin_useres_path, notice: helpers.t_notice('notice_successfully_deleted', User)
  end

  def _set_user
    @user = User.find params[:id]
  end

  def _user_params
    params.require(:user).permit(
      *User::FIELDS
    )
  end
end
