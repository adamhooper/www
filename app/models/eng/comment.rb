class Eng::Comment < AbstractComment
  set_table_name :eng_comments

  belongs_to :article, :foreign_key => 'eng_article_id'

  validates_presence_of :eng_article_id
end
