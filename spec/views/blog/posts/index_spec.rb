require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/blog/posts/index" do
  before(:each) do
    @empty_list = mock('empty list proxy')
    @empty_list.stub!(:each).and_yield([])
    @empty_list.stub!(:count).and_return(0)
    @empty_list.stub!(:collect).and_return('')

    @post1 = mock_model(Blog::Post)
    @post1.stub!(:created_at).and_return(DateTime.now - 1.day)
    @post1.stub!(:title).and_return('Test One')
    @post1.stub!(:tags).and_return(@empty_list)
    @post1.stub!(:comments).and_return(@empty_list)
    @post1.stub!(:format).and_return('html')
    @post1.stub!(:body).and_return('<p>Foo</p>')

    @post2 = mock_model(Blog::Post)
    @post2.stub!(:created_at).and_return(DateTime.now - 3.days)
    @post2.stub!(:title).and_return('Test Two')
    @post2.stub!(:tags).and_return(@empty_list)
    @post2.stub!(:comments).and_return(@empty_list)
    @post2.stub!(:format).and_return('html')
    @post2.stub!(:body).and_return('<p>Bar</p>')

    @posts = [ @post1, @post2 ].paginate :page => 1, :per_page => 10
    assigns[:posts] = @posts
  end

  it "should display the index" do
    render '/blog/posts/index'
  end

  it "should display @post1" do
    render '/blog/posts/index'
    response.should have_tag('div.blog-post-body>p', /Foo/)
  end

  it "should display @post1 title" do
    render '/blog/posts/index'
    response.should have_tag("div#blog-post-#{@post1.id} h2", @post1.title)
  end

  it "should not paginate when there is only one page" do
    render '/blog/posts/index'
    response.should_not have_tag("div.pagination")
  end

  it "should paginate when there are multiple pages" do
    @posts = [ @post1, @post2 ].paginate :page => 1, :per_page => 1
    assigns[:posts] = @posts
    render '/blog/posts/index'
    response.should have_tag("div.pagination")
  end
end
