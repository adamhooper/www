class Blog::Comment < ActiveRecord::Base
  include AbstractComment

  set_table_name :blog_comments

  belongs_to :post, :foreign_key => 'blog_post_id'

  validates_presence_of :blog_post_id
end
