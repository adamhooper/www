class Blog::Comment < ActiveRecord::Base
  set_table_name :blog_comments

  belongs_to :post, :foreign_key => 'blog_post_id'

  validates_presence_of :blog_post_id, :author_name, :author_ip, :body
  validate :ensure_has_website_or_email

  private

  def ensure_has_website_or_email
    if author_email.blank? && author_website.blank?
      errors.add(:author_email, 'must be specified')
    end
  end
end
