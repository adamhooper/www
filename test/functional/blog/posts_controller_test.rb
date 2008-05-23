require 'test_helper'

class Blog::PostsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:blog_posts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post
    assert_difference('Blog::Post.count') do
      post :create, :post => { }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  def test_should_show_post
    get :show, :id => blog_posts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => blog_posts(:one).id
    assert_response :success
  end

  def test_should_update_post
    put :update, :id => blog_posts(:one).id, :post => { }
    assert_redirected_to post_path(assigns(:post))
  end

  def test_should_destroy_post
    assert_difference('Blog::Post.count', -1) do
      delete :destroy, :id => blog_posts(:one).id
    end

    assert_redirected_to blog_posts_path
  end
end
