# Building a Blog with Rails 7

[https://gorails.com/series/build-a-blog-with-rails-7](https://gorails.com/series/build-a-blog-with-rails-7)

## [Creating a New Rails app](https://gorails.com/episodes/blog-rails-new)

```bash
rails new blog
```

## [The MVC Pattern Explained](https://gorails.com/episodes/the-mvc-pattern-explained)

The Model-View-Controller (MVC) pattern is a software architectural pattern that
separates an application into three interconnected components:

- **Model**: Represents the data and business logic of the application. It
  interacts with the database and contains the rules for how data can be
  created, read, updated, and deleted (CRUD operations).

- **View**: Represents the user interface of the application. It displays data
  to the user and sends user commands to the controller.

- **Controller**: Acts as an intermediary between the Model and the View. It
  processes user input, interacts with the Model to retrieve or modify data, and
  updates the View accordingly.

- **Routes**: Defines the URL patterns and maps them to specific controller
  actions. It determines how incoming requests are handled by the application.

## [Rails Application Structure Explained](https://gorails.com/episodes/rails-application-structure-explained)

| File/Folder      | Purpose                                                                                                                                                           |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `app/`           | Contains controllers, models, views, helpers, mailers, jobs, and assets for your application. You'll focus mostly on this folder for the remainder of this guide. |
| `bin/`           | Contains the Rails script that starts your app and other scripts for setup, update, deployment, or running your application.                                      |
| `config/`        | Contains configuration for routes, database, and more. Covered in more detail in Configuring Rails Applications.                                                  |
| `config.ru`      | Rack configuration for Rack-based servers used to start the application.                                                                                          |
| `db/`            | Contains your current database schema and database migrations.                                                                                                    |
| `Dockerfile`     | Configuration file for Docker.                                                                                                                                    |
| `Gemfile`        | Specifies gem dependencies needed for your Rails application. Used by the Bundler gem.                                                                            |
| `Gemfile.lock`   | Locks the gem dependencies for your Rails application. Used by the Bundler gem.                                                                                   |
| `lib/`           | Extended modules for your application.                                                                                                                            |
| `log/`           | Application log files.                                                                                                                                            |
| `public/`        | Contains static files and compiled assets. Exposed as-is when your app is running.                                                                                |
| `Rakefile`       | Loads tasks that can be run from the command line. Add your own tasks in `lib/tasks`.                                                                             |
| `README.md`      | Brief instruction manual for your application. Edit to describe what your application does and how to set it up.                                                  |
| `script/`        | Contains one-off or general purpose scripts and benchmarks.                                                                                                       |
| `storage/`       | Contains SQLite databases and Active Storage files for Disk Service. Covered in Active Storage Overview.                                                          |
| `test/`          | Unit tests, fixtures, and other test apparatus. Covered in Testing Rails Applications.                                                                            |
| `tmp/`           | Temporary files (like cache and pid files).                                                                                                                       |
| `vendor/`        | Third-party code, including vendored gems.                                                                                                                        |
| `.dockerignore`  | Tells Docker which files to exclude from the container.                                                                                                           |
| `.gitattributes` | Defines metadata for specific paths in a Git repository.                                                                                                          |
| `.git/`          | Contains Git repository files.                                                                                                                                    |
| `.github/`       | Contains GitHub specific files.                                                                                                                                   |
| `.gitignore`     | Tells Git which files or patterns to ignore.                                                                                                                      |
| `.kamal/`        | Contains Kamal secrets and deployment hooks.                                                                                                                      |
| `.rubocop.yml`   | Configuration for RuboCop.                                                                                                                                        |
| `.ruby-version`  | Specifies the default Ruby version.                                                                                                                               |

## [Creating A Blog Post Model](https://gorails.com/episodes/creating-a-blog-post-model)

```bash
rails generate model BlogPost title:string body:text
```

```bash
rails db:migrate
```

```bash
rails console

irb(main)> BlogPost.create(title: "Hello World", body: "This is the body of my first post.")
# => #<BlogPost id: 1, title: "Hello World", body: "This is the body of my first post.", created_at: "2023-10-01 12:00:00", updated_at: "2023-10-01 12:00:00">
irb(main)> BlogPost = BlogPost.first
# => #<BlogPost id: 1, title: "Hello World", body: "This is the body of my first post.", created_at: "202
irb(main)> BlogPost.update(title: "Updated Title")
# => #<BlogPost id: 1, title: "Updated Title", body: "This is the body of my first post.", created_at: "2023-10-01 12:00:00", updated_at: "2023-10-01 12:05:00">
irb(main)> BlogPost.destroy
# => #<BlogPost id: 1, title: "Updated Title", body: "This is the body of my first post.", created_at: "2023-10-01 12:00:00", updated_at: "2023-10-01 12:05:00">
```

## [Adding a Blog Index Action](https://gorails.com/episodes/adding-a-blog-index-action)

In `config/routes.rb`, add the following line to set the root route:

```ruby
root "posts#index"
```

Next, generate a controller for the posts:

```bash
rails g controller posts
```

## [Adding a Blog Post Show Action](https://gorails.com/episodes/adding-a-blog-post-show-action)

In `app/controllers/posts_controller.rb`, add the `show` action:

```ruby
def show
  @post = Post.find(params[:id])
rescue ActiveRecord::RecordNotFound
  redirect_to root_path
end
```

In `config/routes.rb`, add the route for the show action:

```ruby
get 'posts/:id', to: 'posts#show', as: 'post'
```

## [Adding a New Blog Post Action](https://gorails.com/episodes/adding-a-new-blog-post-action)

In `config/routes.rb`, add the following routes for creating a new post:

```ruby
get  'posts/new', to: 'posts#new',  as: 'post_new'
post '/posts', to: 'posts#create', as: 'posts'
```

In `app/controllers/posts_controller.rb`, add the `new` and `create` actions:

```ruby
# [...]
def new
  @post = Post.new
end
```

In `app/views/posts/new.html.erb`, create a form for the new post:

```erb
<h1>New Post</h1>

<%= form_with model: @post do |form| %>
  <div>
    <%= form.label :title %>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :body %>
    <%= form.text_area :body %>
  </div>

  <div>
    <%= form.button %>
  </div>
<% end %>
```

## [Creating New Blog Posts](https://gorails.com/episodes/creating-new-blog-posts)

In `app/controllers/posts_controller.rb`, complete the `create` action:

```ruby
def create
  @post = Post.new(post_params)
  if @post.save
    redirect_to @post
  else
    render :new, status: :unprocessable_entity
  end
end

private

def post_params
  params.require(:post).permit(:title, :body)
end
```

In `app/models/post.rb`, add validations to ensure the presence of title and
body:

```ruby
class Post < ApplicationRecord
  validates :title, :body, presence: true
end
```

In `app/views/posts/new.html.erb`, display error messages if the form submission
fails:

```erb
<%= form_with model: @post do |form| %>
  <% if form.object.errors.any? %>
    <div>
      <% form.object.errors.full_messages.each do |message| %>
        <p><%= message %></p>
      <% end %>
    </div>
  <% end %>

  <!-- ... -->
```

## [Edit & Update Blog Post Actions]

In `app/controllers/posts_controller.rb`, add the `edit` and `update` actions:

```ruby
get '/:id/edit', to: 'posts#edit', as: 'edit_post'
patch '/:id', to: 'posts#update'
```

Create form partial in `app/views/posts/_form.html.erb`

In `app/controllers/posts_controller.rb`, add the `edit` and `update` actions:

```ruby
def edit
  @post = Post.find(params[:id])
end

def update
  @post = Post.find(params[:id])
  if @post.update(post_params)
    redirect_to @post
  else
    render :edit, status: :unprocessable_entity
  end
end
```

## [Adding a Blog Post Destroy Action and Refactoring](https://gorails.com/episodes/adding-a-blog-post-destroy-action-and-refactoring)

In `config/routes.rb`, add the route for deleting a post:

```ruby
delete '/posts/:id', to: 'posts#destroy'
```

In `app/controllers/posts_controller.rb`, add the `destroy` action:

```ruby
def destroy
  @post = Post.find(params[:id])
  @post.destroy
  redirect_to root_path, status: :see_other
end
```

In `app/views/posts/show.html.erb`, add a link to delete each post:

```erb
<%= button_to "Delete this post", @post, method: :delete, data: { turbo_confirm: "Are you sure?" } %>
```

### Refactoring

In `config/routes.rb`, use the `resources` method to define all routes for the
`posts` resource:

```ruby
resources :posts
```

In `app/controllers/posts_controller.rb`, use a `before_action` to set the post

for the `show`, `edit`, `update`, and `destroy` actions:

```ruby
before_action :set_post, only: [:show, :edit, :update, :destroy]
# [...]

private

def set_post
  @post = Post.find(params[:id])
end
```

## [Authenticating Blog Admin Pages](https://gorails.com/episodes/authenticating-blog-admin-pages)

To add authentication to the blog admin pages, you can use the `devise` gem.

```bash
bundle add devise
rails generate devise:install
```

In `config/environments/development.rb`:

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

Generate the User model:

```bash
rails generate devise User
rails db:migrate
```

In `app/views/layouts/application.html.erb`:

```erb
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
<% if user_signed_in? %>
  <%= link_to "Profile", edit_user_registration_path %>
  <%= button_to "Log out", destroy_user_session_path, method: :delete %>
<% else %>
  <%= link_to "Sign up", new_user_registration_path %>
  <%= link_to "Log in", new_user_session_path %>
<% end %>
```

This is my blog, so i don't want new registrations, so in `app/models/user.rb`
remove the `:registerable` module:

```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
```

In `db/seeds.rb`, create a default user:

```ruby
user = User.where(email: "test@test.com").first_or_initialize
user.update!(password: "123456", password_confirmation: "123456")
```

In `app/controllers/posts_controller.rb`, add a `before_action` to authenticate
users for the `new`, `create`, `edit`, `update`, and `destroy`

```ruby
before_action :authenticate_user!, except: [:index, :show]
```

Edit de links to only show if the user is signed in:

```erb
<%= link_to "New Post", post_new_path if user_signed_in? %>
<%= link_to "Edit this post", edit_post_path(@post) if user_signed_in? %>
<%= button_to "Delete this post", @post, method: :delete, data: { turbo_confirm: "Are you sure?" } if user_signed_in? %>
```

## [Adding TailwindCSS to Rails](https://gorails.com/episodes/adding-tailwindcss-to-rails)

```bash
bundle add tailwindcss-rails
rails tailwindcss:install
```

Now to run the app you use

```bash
bin/dev
```

For use plugins in tailwindcss, you can add them to
`app/assets/tailwind/application.css`:

```css
@plugin "@tailwindcss/typography";
```

To edit devise views, you can run:

```bash
rails generate devise:views
```

Then you can edit the views in `app/views/devise/`.

## [Deploying our Rails Blog to Production](https://gorails.com/episodes/deploying-our-rails-blog-to-production)

[https://render.com/](https://render.com/)

```bash
rails db:system:change --to=postgresql
bundle
```

## [Adding Scheduled Blog Posts](https://gorails.com/episodes/adding-scheduled-blog-posts)

To add a published_at field to your posts, you need to create a migration:

```bash
rails generate migration AddPublishedAtToPosts published_at:datetime
rails db:migrate
```

In `app/models/post.rb`, add scopes to order, filter posts by their published
status and create a method to check if a post is published:

```ruby
scope :order,     -> { order(published_at: :desc) }
scope :draft,     -> { where(published_at: nil) }
scope :published, -> { where("published_at <= ?", Time.current) }
scope :scheduled, -> { where("published_at > ?",  Time.current) }

def draft?
  published_at.nil?
end

def published?
  published_at? && published_at <= Time.current
end

def scheduled?
  published_at? && published_at > Time.current
end
```

In `app/controllers/posts_controller.rb`, update the `index` to show only
published posts in order:

```ruby
def index
  @posts = user_signed_in? ? Post.all.sorted : Post.published.sorted
end
```

update the `set_post` method to handle scheduled posts:

```ruby
def set_post
  if user_signed_in?
  @post = Post.find(params[:id])
  else
    @post = Post.published.find(params[:id])
  end
rescue ActiveRecord::RecordNotFound
  redirect_to root_path, alert: "Post not found"
end
```

and add a `published_at` in `post_params`:

```ruby
def post_params
  params.require(:post).permit(:title, :body, :published_at)
end
```

In `app/views/posts/_form.html.erb`, add a field for the `published_at`:

```erb
<div>
  <%= form.label :published_at %>
  <%= form.datetime_select :published_at, include_blank: true %>
</div>
```

In `app/views/posts/index.html.erb`, add a logic to view draft, scheduled and
published posts:

```erb
<% @posts.each do |post| %>
  <div>
    <h3><%= link_to post.title, post_path(post) %></h3>
    <% if post.draft? %>
      <p class="text-gray-500">Draft</p>
    <% elsif post.scheduled? %>
      <p class="text-yellow-500">Scheduled: <%= post.published_at.strftime("%B %d, %Y") %></p>
    <% else %>
      <p>Published at: <%= post.published_at.strftime("%B %d, %Y") if post.published_at %></p>
    <% end %>
    <p><%= post.body %></p>
  </div>
<% end %>
```

## [Writing Tests for Scheduled Blog Posts](https://gorails.com/episodes/writing-tests-for-scheduled-blog-posts)

In `test/fixtures/posts.yml`, add a posts exemples:

```yaml
draft:
  title: draft post
  body: MyText
  published_at: null

published:
  title: published post
  body: MyText
  published_at: <%= 1.year.ago %>

scheduled:
  title: scheduled post
  body: MyText
  published_at: <%= 1.year.from_now %>
```

In `test/models/post_test.rb`, add tests for the scopes and methods:

```ruby
  test "draft? returns true for draft post" do
  assert posts(:draft).draft?
end

test "draft? returns false for published post" do
  refute posts(:published).draft?
end

test "draft? returns false for scheduled post" do
  refute posts(:scheduled).draft?
end

test "published? returns true for published post" do
  assert posts(:published).published?
end

test "published? returns false for draft post" do
  refute posts(:draft).published?
end

test "published? returns false for scheduled post" do
  refute posts(:scheduled).published?
end

test "scheduled? returns true for scheduled post" do
  assert posts(:scheduled).scheduled?
end

test "scheduled? returns false for draft post" do
  refute posts(:draft).scheduled?
end

test "scheduled? returns false for published post" do
  refute posts(:published).scheduled?
end
```

## [Sorting Blog Posts With Scopes](https://gorails.com/episodes/sorting-blog-posts-with-scopes)

In `app/models/post.rb`, add a scope to sort posts and draft posts at the
beginning:

```ruby
 scope :sorted,    -> { order(arel_table[:published_at].desc.nulls_first).order(updated_at: :desc) }
```

## [Rich Text Blog Posts with ActionText](https://gorails.com/episodes/rich-text-blog-posts-with-actiontext)

```bash
rails action_text:install
rails db:migrate
```

In `app/models/post.rb`, add the `has_rich_text` association:

```ruby
has_rich_text :body
# [...]
```

In `app/views/posts/_form.html.erb`, replace the text area for the body with a
rich text editor:

```erb
<div>
  <%= form.label :body %>
  <%= form.rich_text_area :body, class: "prose" %>
</div>
```

## [How to Add Pagination for Blog Posts in Rails](https://gorails.com/episodes/how-to-add-pagination-for-blog-posts-in-rails)

Use the [pagy gem](https://github.com/ddnexus/pagy)

### pagy installation

```bash
bundle add pagy
```

In `app/controllers/application_controller.rb`, include the Pagy module:

```ruby
include Pagy::Backend
```

In `app/helpers/application_helper.rb`, include the Pagy module:

```ruby
include Pagy::Frontend
```

In `app/controllers/ApplicationController.rb`, add the `pagy` method to paginate

```ruby
class ApplicationController < ActionController::Base
  include Pagy::Backend
end
```

In `app/helpers/application_helper.rb`, include the Pagy module:

```ruby
module ApplicationHelper
  include Pagy::Frontend
end
```

In `app/controllers/posts_controller.rb`, update the `index` action to use Pagy:

```ruby
def index
  @posts = user_signed_in? ? Post.sorted.all : Post.published.sorted
  @pagy, @posts = pagy(@posts, limit: 5)
rescue Pagy::OverflowError
  redirect_to root_path, alert: "No more posts available"
end
```

Finally, in `app/views/posts/index.html.erb`, add the Pagy pagination links:

```erb
<%== pagy_nav(@pagy)  %>
```

## [Upload Cover Images in Rails with ActiveStorage](https://gorails.com/episodes/upload-cover-images-in-rails-with-activestorage)

In `app/models/post.rb`, add the `has_one_attached` association for the cover
image:

```ruby
has_one_attached :cover_image
```

In `app/controllers/posts_controller.rb`, permit the `cover_image` parameter in
`post_params`:

```ruby
def post_params
  params.require(:post).permit(:title, :body, :published_at, :cover_image)
end
```

In `app/views/posts/_form.html.erb`, add a file field for the cover image:

```erb
<%= image_tag @post.cover_image if @post.cover_image.present? %>
<div>
  <%= form.label :cover_image %>
  <%= form.file_field :cover_image %>
</div>
```

In `app/views/posts/show.html.erb`, display the cover image if it exists:

```erb
<%= image_tag @post.cover_image if @post.cover_image.present? %>
```

### Remove cover image

In `config/routes.rb`, add a route to remove the cover image:

```ruby
resources :posts do
  resource :cover_image, only: [:destroy], module: :posts
end
```

Create a new controller `app/controllers/posts/cover_images_controller.rb`:

```ruby
class Posts::CoverImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def destroy
    @post.cover_image.purge_later
    redirect_to edit_post_path(@post), notice: "Cover image was successfully removed."
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
```

In `app/views/posts/form.html.erb`, add a link to remove the cover image:

```erb
<%= link_to "Remove cover image", post_cover_image_path(@post), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" } %>
```
