class Blog::PostsController < Blog::BaseController
  before_filter :authorize, :except => [ :index, :show ]

  def index
    load_all_tag_names

    respond_to do |format|
      format.html do
        @posts = current_posts
      end
      format.rss do
        if params[:fb] || params[:tag] || params[:page]
          @posts = current_posts
          render :layout => false
        else
          redirect_to 'http://feeds2.feedburner.com/adamhooper'
        end
      end
    end
  end

  def show
    load_all_tag_names

    @post = current_post
    @comments = current_visible_comments
    @new_comment = @post.comments.build(:author_ip => request.remote_ip)
  end

  def new
    @post = Blog::Post.new
  end

  def edit
    @post = current_post
  end

  def create
    @post = Blog::Post.new(params[:blog_post])
    if @post.save
      redirect_to([:blog, @post], :notice => 'Blog post created')
    else
      render(:new)
    end
  end

  def update
    @post = current_post
    if @post.update_attributes(params[:blog_post])
      redirect_to([:blog, @post], :notice => 'Blog post updated')
    else
      render(:edit)
    end
  end

  def destroy
    current_post.destroy
    redirect_to([:blog, :index], :notice => 'Blog post deleted')
  end

  private

  def current_visible_comments
    if admin? && params[:spam]
      current_post.comments
    else
      current_post.comments.hammy
    end
  end

  def current_posts
    Blog::Post
      .with_tag(params[:tag])
      .order('blog_posts.created_at DESC')
      .paginate(:per_page => 10, :page => params[:page])
  end

  def current_post
    @_current_post ||= Blog::Post.find(params[:id])
  end
end
