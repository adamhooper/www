class Blog::Comment < AbstractComment
  self.table_name = 'blog_comments'

  belongs_to :post, :foreign_key => 'blog_post_id'
  def parent; post; end

  validates_presence_of :blog_post_id
  scope :hammy, where(:spam_status => [ 'akismet-says-ham', 'admin-says-ham', 'unverified' ])
end
