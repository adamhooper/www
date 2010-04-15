class Blog::CommentObserver < ActiveRecord::Observer
  def after_create(record)
    Blog::CommentNotifier.new_comment(record).deliver
  end
end
