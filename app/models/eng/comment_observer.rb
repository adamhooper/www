class Eng::CommentObserver < ActiveRecord::Observer
  def after_create(record)
    Eng::CommentNotifier.deliver_new_comment(record)
  end
end
