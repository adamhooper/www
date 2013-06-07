class AbstractComment < ActiveRecord::Base
  self.abstract_class = true

  include Rakismet::Model

  rakismet_attrs(
    :author => :author_name,
    :author_url => :author_website,
    :content => :body,
    :permalink => proc { parent.permalink },
    :remote_ip => :author_ip
  )

  module RakismetBehavior
    def ham!
      super
      self.spam_status = 'admin-says-ham'
    end

    def spam!
      super
      self.spam_status = 'admin-says-spam'
    end
  end

  include RakismetBehavior

  validates_presence_of(:author_name, :author_ip, :body)

  validate do
    if author_email.blank? && author_website.blank?
      errors.add(:author_email, 'cannot be empty')
    end
  end

  before_create do |comment|
    comment.spam_status = comment.spam? && 'akismet-says-spam' || 'akismet-says-ham'
  end
end
