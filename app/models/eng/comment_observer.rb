class Eng::CommentObserver < ActiveRecord::Observer
  def after_create(record)
    Eng::CommentNotifier.new_comment(record).deliver
  end
end
