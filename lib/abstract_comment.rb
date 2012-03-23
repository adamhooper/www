module AbstractComment
  def self.included(base)
    base.validates_presence_of(:author_name, :author_ip, :body)
    base.validate do
      if author_email.blank? && author_website.blank?
        errors.add(:author_email, 'cannot be empty')
      end
    end
  end
end
