class AbstractComment < ActiveRecord::Base
  validates_presence_of :author_name, :author_ip, :body
  validate :ensure_has_website_or_email

  private

  def ensure_has_website_or_email
    if author_email.blank? && author_website.blank?
      errors.add(:author_email, 'must be specified')
    end
  end
end
