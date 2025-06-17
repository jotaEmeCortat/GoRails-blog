class AddAuthorIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :author_id, :integer
  end
end
