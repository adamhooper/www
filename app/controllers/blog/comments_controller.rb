class Blog::CommentsController < Blog::BaseController
  before_filter :authorize, :except => [ :new, :create ]

  def new
    load_all_tag_names

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
    @post = post
    @comment = @post.comments.build(params[:blog_comment].merge(:author_ip => request.remote_ip))

    respond_to do |format|
      #if verify_recaptcha(:model => @comment) && @comment.save
      if @comment.save
        if @comment.spam_status =~ /spam\Z/
          flash[:notice] = 'Your comment has been marked as spam, so it will not appear. Email me to resolve this.'
        else
          flash[:notice] = 'Thank you for your comment.'
        end
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def spam
    @comment = comment
    @comment.spam!

    if @comment.save
      flash[:notice] = 'Comment was marked as spam'
      redirect_to(post)
    end
  end

  def ham
    @comment = comment
    @comment.ham!

    if @comment.save
      flash[:notice] = 'Comment was marked as ham'
      redirect_to(post)
    end
  end

  def destroy
    comment.destroy
    flash[:notice] = 'Comment was destroyed'

    respond_to do |format|
      format.html { redirect_to(post) }
      format.xml { head :ok }
    end
  end

  private

  def post
    @_post ||= Blog::Post.find(params[:post_id])
  end

  def comment
    @_comment ||= Blog::Comment.find(params[:id])
  end
end
