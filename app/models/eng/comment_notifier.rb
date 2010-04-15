class Eng::CommentNotifier < ActionMailer::Base
  default :from => 'adam@adamhooper.com'

  def new_comment(comment)
    @comment = comment
    mail(:to => 'adam@adamhooper.com', :subject => 'AH.com: New Eng comment')
  end
end
