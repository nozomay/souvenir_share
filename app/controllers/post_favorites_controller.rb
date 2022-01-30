class PostFavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.new(post_id: post.id)
    @post_favorite.save
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_favorite = current_user.post_favorites.new(post_id: post.id)
    @post_favorite.destroy
    redirect_to post_path(@post)
  end
end
