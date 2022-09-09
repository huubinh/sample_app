class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t(".post_created")
      redirect_to root_url
    else
      handle_create_failed
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t(".post_deleted")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_back fallback_location: root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t(".invalid_account")
    redirect_to root_url
  end

  def handle_create_failed
    @pagy, @feed_items = pagy current_user.feed,
                              items: Settings.micropost.micropost_per_page
    flash.now[:danger] = t(".create_failed")
    render "static_pages/home"
  end
end
