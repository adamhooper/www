require 'test_helper'

class Blog::CommentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:blog_comments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_comment
    assert_difference('Blog::Comment.count') do
      post :create, :comment => { }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  def test_should_show_comment
    get :show, :id => blog_comments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => blog_comments(:one).id
    assert_response :success
  end

  def test_should_update_comment
    put :update, :id => blog_comments(:one).id, :comment => { }
    assert_redirected_to comment_path(assigns(:comment))
  end

  def test_should_destroy_comment
    assert_difference('Blog::Comment.count', -1) do
      delete :destroy, :id => blog_comments(:one).id
    end

    assert_redirected_to blog_comments_path
  end
end
