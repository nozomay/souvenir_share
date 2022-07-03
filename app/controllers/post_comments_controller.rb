class PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
      redirect_to post_path(post)
    else
      @error_comment = comment
      @post = Post.find(params[:post_id])
      @user = @post.user
      @post_tags = @post.tags
      @post_comment = PostComment.new
      render 'posts/show'
    end
  end

  def destroy
    PostComment.find_by(id: params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
