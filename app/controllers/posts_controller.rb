class PostsController < ApplicationController
  before_action :move_to_signed_in
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.page(params[:page]).per(27)
    @tag_list = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
    @comment = PostComment.page(params[:page]).per(5)
    @post_tags = @post.tags
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_tag(tag_list)
      flash[:notice] = "投稿完了しました"
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      @old_ralations = PostTag.where(post_id: @post.id)
      @old_ralations.each do |relation|
        relation.delete
      end
      @post.save_tag(tag_list)
      flash[:notice] = "投稿内容を変更しました"
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to posts_path
  end

  def search_tag
    @tag_list = Tag.page(params[:page]).per(40)
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
  end

  def search_post
    @range = params[:range]
    if @range == "ユーザー"
      @users = User.looks(params[:content])
    else
      @posts = Post.looks(params[:content])
    end
  end

  private
  def post_params
    params.require(:post).permit(:image, :title, :review, :rate, :address)
  end

  def move_to_signed_in
    unless user_signed_in?
      redirect_to  new_user_session_path
    end
  end

  def correct_user
    unless Post.find(params[:id]).user_id == current_user.id
        redirect_to "/posts"
    end
  end
end