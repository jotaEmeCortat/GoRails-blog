# Tutorial Series

## Build a Blog with Rails 7

- [Creating a New Rails app](docs/Build-a-Blog-with-Rails-7.md#creating-a-new-rails-app)
- [The MVC Pattern Explained](docs/Build-a-Blog-with-Rails-7.md#the-mvc-pattern-explained)
- [Rails Application Structure Explained](docs/Build-a-Blog-with-Rails-7.md#rails-application-structure-explained)
- [Creating A Blog Post Model](docs/Build-a-Blog-with-Rails-7.md#creating-a-blog-post-model)
- [Adding a Blog Index Action](docs/Build-a-Blog-with-Rails-7.md#adding-a-blog-index-action)
- [Adding a Blog Post Show Action](docs/Build-a-Blog-with-Rails-7.md#adding-a-blog-post-show-action)
- [Adding a New Blog Post Action](docs/Build-a-Blog-with-Rails-7.md#adding-a-new-blog-post-action)
- [Creating New Blog Posts](docs/Build-a-Blog-with-Rails-7.md#creating-new-blog-posts)
- [Edit & Update Blog Post Actions](docs/Build-a-Blog-with-Rails-7.md#edit--update-blog-post-actions)
- [Adding a Blog Post Destroy Action and Refactoring](docs/Build-a-Blog-with-Rails-7.md#adding-a-blog-post-destroy-action-and-refactoring)
- [Authenticating Blog Admin Pages](docs/Build-a-Blog-with-Rails-7.md#authenticating-blog-admin-pages)
- [Adding TailwindCSS to Rails](docs/Build-a-Blog-with-Rails-7.md#adding-tailwindcss-to-rails)
- [Deploying our Rails Blog to Production](docs/Build-a-Blog-with-Rails-7.md#deploying-our-rails-blog-to-production)
- [Adding Scheduled Blog Posts](docs/Build-a-Blog-with-Rails-7.md#adding-scheduled-blog-posts)
- [Writing Tests for Scheduled Blog Posts](docs/Build-a-Blog-with-Rails-7.md#writing-tests-for-scheduled-blog-posts)
- [Sorting Blog Posts With Scopes](docs/Build-a-Blog-with-Rails-7.md#sorting-blog-posts-with-scopes)
- [Rich Text Blog Posts with ActionText](docs/Build-a-Blog-with-Rails-7.md#rich-text-blog-posts-with-actiontext)
- [How to Add Pagination for Blog Posts in Rails](docs/Build-a-Blog-with-Rails-7.md#how-to-add-pagination-for-blog-posts-in-rails)
- [Upload Cover Images in Rails with ActiveStorage](docs/Build-a-Blog-with-Rails-7.md#upload-cover-images-in-rails-with-activestorage)

## Add Author to the Posts

First create a new migration to add an `author_id` column to the `posts` table:

```bash
rails generate migration AddAuthorIdToPosts author_id:integer
```

In `app/models/post.rb`, add the association:

```ruby
belongs_to :author, class_name: "User", foreign_key: "author_id"
```

In `app/models/user.rb`, add the association:

```ruby
has_many :posts, foreign_key: "author_id"
```

In `app/controllers/posts_controller.rb`, update the `create` action to set the
author:

```ruby
#  [...]
@post.author = current_user
```
