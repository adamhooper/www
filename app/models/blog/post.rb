class Blog::Post < ActiveRecord::Base
  set_table_name :blog_posts

  has_and_belongs_to_many :tags, :class_name => 'Tag', :join_table => 'blog_posts_tags', :foreign_key => 'blog_post_id'

  validates_presence_of :title, :body, :format
  validates_uniqueness_of :title, :body

  def html
    case format
    when 'html' then html_html
    else "FIXME: invalid format"
    end
  end

  def html_html
    body
  end
end
