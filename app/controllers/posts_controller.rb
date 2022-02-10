class PostsController < ApplicationController
  before_action :move_to_signed_in, except: [:index]

  def index
    @posts = Post.all
    @tag_list = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
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

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.all
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
    redirect_to posts_path
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
end
