class Blog::CommentObserver < ActiveRecord::Observer
  def after_create(record)
    Blog::CommentNotifier.deliver_new_comment(record)
  end
end
