class Portfolio::Piece < ActiveRecord::Base
  self.table_name = 'portfolio_pieces'

  validates_presence_of :title, :published_at, :url, :subtitle, :image_html, :hack_blurb, :hacker_blurb, :permalink
  validates_uniqueness_of :title, :url

  before_validation(on: :create) { build_permalink }

  private

  def build_permalink
    self.permalink = "#{published_at.try(:to_s)}-#{title.try(:parameterize)}"
  end
end
