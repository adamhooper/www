class Eng::Comment < AbstractComment
  self.table_name = 'eng_comments'

  belongs_to :article, :foreign_key => 'eng_article_id'
  def parent; article; end

  validates_presence_of :eng_article_id
  scope :hammy, where(:spam_status => [ 'akismet-says-ham', 'admin-says-ham', 'unverified' ])
end
