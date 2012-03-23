class Blog::CommentsController < Blog::BaseController
  before_filter :authorize, :except => [ :new, :create ]

  def new
    @post = Blog::Post.find(params[:post_id])
    @comment = @post.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # POST /blog_comments
  # POST /blog_comments.xml
  def create
    @post = Blog::Post.find(params[:post_id])
    @comment = @post.comments.build(params[:blog_comment].merge(:author_ip => request.remote_ip))

    respond_to do |format|
      if verify_recaptcha(:model => @comment) && @comment.save
        flash[:notice] = 'Blog::Comment was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    post = Blog::Post.find(params[:post_id])
    comment = Blog::Comment.find(params[:id])

    comment.destroy
    flash[:notice] = 'Comment was destroyed'

    respond_to do |format|
      format.html { redirect_to(post) }
      format.xml { head :ok }
    end
  end
end
