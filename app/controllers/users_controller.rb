class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy User.activated.order(Settings.user.index_user_order),
                         items: Settings.user.user_per_page
  end

  def show
    return if @user.activated?

    flash[:danger] = t(".unactivated_account")
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".check_email")
      redirect_to root_url
    else
      flash.now[:danger] = t(".signup_failed")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t(".user_updated")
      redirect_to @user
    else
      flash.now[:danger] = t(".update_failed")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".user_deleted")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".login_required")
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t(".user_not_found")
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t(".wrong_user")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t(".admin_required")
    redirect_to root_url
  end
end
