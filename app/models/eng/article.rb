class Eng::Article < ActiveRecord::Base
  set_table_name :eng_articles

  has_many :comments, :foreign_key => 'eng_article_id'

  validates_presence_of :title, :body
end
