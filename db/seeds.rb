# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require "open-uri"

user = User.where(email: "test@test.com").first_or_initialize
user.update!(password: "123456", password_confirmation: "123456")

Post.destroy_all

20.times do
  paragraphs = Array.new(8) { Faker::Lorem.paragraph(sentence_count: rand(4..8)) }
  body = paragraphs.map { |p| "<p>#{p}</p>" }.join

  post = Post.create!(
    title: Faker::Book.title,
    body: body,
    published_at: Faker::Date.between(from: '2024-01-01', to: '2025-12-31'),
    author: user
  )

    image_url = "https://picsum.photos/600/400?random=#{rand(1..1000)}"
  post.cover_image.attach(
    io: URI.open(image_url),
    filename: "random-#{post.id}.jpg",
    content_type: "image/jpeg"
  )

  puts "Created post with ID: #{post.id}, Title: '#{post.title}'"
  post.save!
end

draft_post = Post.create!(
    title: Faker::Book.title,
    body: Faker::Lorem.paragraph(sentence_count: 5),
    published_at: nil,
    author: user
  )
  puts "Created post with ID: #{draft_post.id}, Title: '#{draft_post.title}'"
  draft_post.save!
