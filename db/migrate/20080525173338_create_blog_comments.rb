class CreateBlogComments < ActiveRecord::Migration
  def self.up
    create_table :blog_comments do |t|
      t.integer :blog_post_id, :null => false
      t.string :author_name, :null => false, :default => ''
      t.string :author_ip, :null => false, :default => ''
      t.string :author_website, :null => false, :default => ''
      t.string :author_email, :null => false, :default => ''
      t.text :body, :null => false, :default => ''

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_comments
  end
end
