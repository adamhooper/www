class Blog::Post < ActiveRecord::Base
  set_table_name :blog_posts

  has_many :comments, :foreign_key => 'blog_post_id'
  has_and_belongs_to_many :tags, :class_name => 'Tag', :join_table => 'blog_posts_tags', :foreign_key => 'blog_post_id'

  named_scope :with_tag, lambda { |*args| args.first && { :include => 'tags', :conditions => { 'tags.name' => args.first } } || {} }

  validates_presence_of :title, :body, :format
  validates_uniqueness_of :title, :body
end
