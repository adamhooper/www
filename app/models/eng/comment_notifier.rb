class Eng::CommentNotifier < ActionMailer::Base
  def new_comment(comment, sent_at = Time.now)
    subject    'www.AH.com: New Eng comment'
    recipients 'adam@adamhooper.com'
    from       'adam@adamhooper.com'
    sent_on    sent_at
    
    body       :comment => comment
  end
end
