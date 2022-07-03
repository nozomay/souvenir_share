class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :favorites]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(9).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    favorite_post_ids = PostFavorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorite_post_ids).page(params[:page]).per(27)
  end

private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless @user == current_user
  end
end