class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.string :format, :null => false, :default => 'html'

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_posts
  end
end
