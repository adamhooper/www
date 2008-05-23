class CreateBlogPostsTags < ActiveRecord::Migration
  def self.up
    create_table :blog_posts_tags, :id => false do |t|
      t.references :blog_post
      t.references :tag
    end
    add_index :blog_posts_tags, :blog_post_id
    add_index :blog_posts_tags, :tag_id
    add_index :blog_posts_tags, [ :blog_post_id, :tag_id ], :unique => true
  end

  def self.down
    drop_table :blog_posts_tags
  end
end
