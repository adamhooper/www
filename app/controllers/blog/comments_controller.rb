class Blog::CommentsController < ApplicationController
  # GET /blog_comments
  # GET /blog_comments.xml
  def index
    @blog_comments = Blog::Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_comments }
    end
  end

  # GET /blog_comments/1
  # GET /blog_comments/1.xml
  def show
    @comment = Blog::Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /blog_comments/new
  # GET /blog_comments/new.xml
  def new
    @post = Blog::Post.find(params[:post_id])
    @comment = @post.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /blog_comments/1/edit
  def edit
    @comment = Blog::Comment.find(params[:id])
  end

  # POST /blog_comments
  # POST /blog_comments.xml
  def create
    @post = Blog::Post.find(params[:post_id])
    @comment = @post.comments.build(params[:blog_comment].merge(:author_ip => request.remote_ip))

    captcha_valid = simple_captcha_valid?

    respond_to do |format|
      if captcha_valid && @comment.save
        flash[:notice] = 'Blog::Comment was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        unless captcha_valid # Ugly, but better than in validation
          @comment.errors.add_to_base 'Secret Code does not match the image'
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_comments/1
  # PUT /blog_comments/1.xml
  def update
    @comment = Blog::Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:blog_comment])
        flash[:notice] = 'Blog::Comment was successfully updated.'
        format.html { redirect_to([@comment.post, @comment]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_comments/1
  # DELETE /blog_comments/1.xml
  def destroy
    @comment = Blog::Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(blog_post_url(@comment.post)) }
      format.xml  { head :ok }
    end
  end
end
