class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.all
  end

  def show
    @blog_post = BlogPost.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, flash: { error: "Blog post not found" }
  end
end
