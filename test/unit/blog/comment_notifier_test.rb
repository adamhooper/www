require 'test_helper'

class Blog::CommentNotifierTest < ActionMailer::TestCase
  tests Blog::CommentNotifier
  def test_new_comment
    @expected.subject = 'Blog::CommentNotifier#new_comment'
    @expected.body    = read_fixture('new_comment')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Blog::CommentNotifier.create_new_comment(@expected.date).encoded
  end

end
