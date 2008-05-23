class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :blog_posts, :class_name => 'Blog::Post', :join_table => 'blog_posts_tags', :association_foreign_key => 'blog_post_id'
end
