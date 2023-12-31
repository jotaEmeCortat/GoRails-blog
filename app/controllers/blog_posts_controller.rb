class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_posts, only: %i[show edit update destroy]

  def index
    @blog_posts = BlogPost.all
  end

  def show
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, flash: { error: 'Blog post not found' }
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)

    if @blog_post.save
      redirect_to blog_post_path(@blog_post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to blog_post_path(@blog_post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to root_path
  end

  private

  def set_blog_posts
    @blog_post = BlogPost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def blog_post_params
    params.require(:blog_post).permit(:title, :body)
  end
end
