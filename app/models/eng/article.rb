class Eng::Article < ActiveRecord::Base
  self.table_name = 'eng_articles'

  has_many :comments, :foreign_key => 'eng_article_id'

  validates_presence_of :title, :body

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def permalink
    "http://adamhooper.com/eng/articles/#{to_param}"
  end
end
