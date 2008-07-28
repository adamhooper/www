require File.dirname(__FILE__) + '/../../spec_helper'

describe Blog::PostsController do
  before(:each) do
    @comment = mock_model(Blog::Comment)
    @comments = mock('blog::comments proxy')
    @comments.stub!(:each).and_yield([@comment])
    @post = mock_model(Blog::Post, :comments => @comments)
    Blog::Post.stub!(:new).and_return(@post)
  end

  describe 'GET :index' do
    before :each do
      @posts = Array.new(2) { mock_model(Blog::Post) }
      Blog::Post.stub!(:find).and_return(@posts)
    end

    it "should load a paginated list of all categories" do
      Blog::Post.should_receive(:paginate).and_return(@posts)
      get :index
    end

    it "should assign @posts" do
      get :index
      assigns[:posts].should == @posts
    end

    it "should render the :index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe 'GET :show' do
    before :each do
      Blog::Post.stub!(:find).and_return(@post)
      @new_comment = mock_model(Blog::Comment)
      @comments.stub!(:build).and_return(@new_comment)
    end

    it "should load the requested post" do
      #Blog::Post.should_receive(:find).with('4').and_return(@post)
      get :show, :id => 4
    end

    it "should assign @post" do
      get :show, :id => 4
      assigns[:post].should == @post
    end

    it "should render the :show template" do
      get :show, :id => 4
      response.should render_template(:show)
    end

    it "should assign @new_comment" do
      get :show, :id => 4
      assigns[:new_comment].should == @new_comment
    end
  end

  describe 'GET :new' do
    before(:each) do
      controller.stub!(:admin?).and_return(true)
    end

    it "should create a new post" do
      Blog::Post.should_receive(:new).and_return(@post)
      get :new
    end

    it "should assign @post" do
      get :new
      assigns[:post].should == @post
    end

    it "should render the :new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe 'POST :create' do
    before(:each) do
      controller.stub!(:admin?).and_return(true)
    end

    describe "when successful" do
      before(:each) do
        @post.stub!(:save).and_return(true)
      end

      it "should create the post" do
        Blog::Post.should_receive(:new).with('title' => 'Title').and_return(@post)
        post :create, :post => { :title => 'Title' }
      end

      it "should save the post" do
        @post.should_receive(:save).and_return(true)
        post :create
      end

      it "should redirect to the show action" do
        post :create
        response.should redirect_to(blog_post_url(@post))
      end
    end

    describe "when unsuccessful" do
      before :each do
        @post.stub!(:save).and_return(false)
      end

      it "should assign @post" do
        post :create, :post => { :title => 'Title' }
        assigns[:post].should == @post
      end

      it "should put a message in flash[:error]" do
        post :create
        flash[:error].should == 'There was a problem!'
      end

      it "should render the :new template" do
        post :create
        response.should render_template(:new)
      end
    end
  end

  describe "GET :edit" do
    before :each do
      Blog::Post.stub!(:find).and_return(@post)
      controller.stub!(:admin?).and_return(true)
    end

    it "should load the requested post" do
      Blog::Post.should_receive(:find).with('4').and_return(@post)
      get :edit, :id => 4
    end

    it "should assign @post" do
      get :edit
      assigns[:post].should == @post
    end

    it "should render the :edit template" do
      get :edit
      response.should render_template(:edit)
    end
  end

  describe "PUT :update" do
    before :each do
      Blog::Post.stub!(:find).and_return(@post)
      controller.stub!(:admin?).and_return(true)
    end

    describe "when successful" do
      before :each do
        @post.stub!(:update_attributes).and_return(true)
      end

      it "should load the requested post" do
        Blog::Post.should_receive(:find).with('4').and_return(@post)
        put :update, :id => 4
      end

      it "should update the post's attributes" do
        @post.should_receive(:update_attributes).with('title' => 'Title').and_return(true)
        put :update, :post => { :title => 'Title' }
      end

      it "should put a message in flash[:notice]" do
        put :update
        flash[:notice].should == 'Save successful!'
      end

      it "should redirect to the :show action" do
        put :update
        response.should redirect_to(blog_post_url(@post))
      end
    end

    describe "when unsuccessful" do
      before :each do
        @post.stub!(:update_attributes).and_return(false)
      end

      it "should assign @post" do
        put :update
        assigns[:post].should == @post
      end

      it "should put a message in flash[:error]" do
        put :update
        flash[:error].should == 'There was a problem saving!'
      end

      it "should render the :edit template" do
        put :update
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE :destroy" do
    before(:each) do
      Blog::Post.stub!(:find).and_return(@post)
      controller.stub!(:admin?).and_return(true)
    end

    describe "when successful" do
      before :each do
        @post.stub!(:destroy).and_return(true)
      end

      it "should load the requested post" do
        Blog::Post.should_receive(:find).with('4').and_return(@post)
        delete :destroy, :id => 4
      end

      it "should destroy the requested post" do
        @post.should_receive(:destroy).and_return(true)
        delete :destroy
      end

      it "should put a message in flash[:notice]" do
        delete :destroy
        flash[:notice].should == 'Record deleted!'
      end

      it "should redirect to the posts url" do
        delete :destroy
        response.should redirect_to(blog_posts_url)
      end
    end

    describe "when unsuccessful" do
      before :each do
        @post.stub!(:destroy).and_return(false)
        @request.env['HTTP_REFERER'] = 'http://referer'
      end

      it "should assign @post" do
        delete :destroy
        assigns[:post].should == @post
      end

      it "should put a message in flash[:error]" do
        delete :destroy
        flash[:error].should == 'There was a problem deleting!'
      end

      it "should redirect to the referer" do
        delete :destroy
        response.should redirect_to('http://referer')
      end
    end
  end
end
