class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  def index
    @posts = user_signed_in? ? Post.sorted.all : Post.published.sorted
    @pagy, @posts = pagy(@posts, limit: 5)
  rescue Pagy::OverflowError
    redirect_to root_path, alert: "No more posts available"
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path status: :see_other
  end


  private

  def set_post
    if user_signed_in?
    @post = Post.find(params[:id])
    else
      @post = Post.published.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Post not found"
  end

  def post_params
    params.require(:post).permit(:cover_image, :title, :body, :published_at)
  end
end
