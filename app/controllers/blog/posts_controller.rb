class Blog::PostsController < ApplicationController
  # GET /blog_posts
  # GET /blog_posts.xml
  def index
    @posts = Blog::Post.paginate(
      :page => params[:page], 
      :order => 'created_at DESC'
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /blog_posts/1
  # GET /blog_posts/1.xml
  def show
    @post = Blog::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /blog_posts/new
  # GET /blog_posts/new.xml
  def new
    @post = Blog::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /blog_posts/1/edit
  def edit
    @post = Blog::Post.find(params[:id])
  end

  # POST /blog_posts
  # POST /blog_posts.xml
  def create
    @post = Blog::Post.new(params[:blog_post])

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Blog::Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_posts/1
  # PUT /blog_posts/1.xml
  def update
    @post = Blog::Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:blog_post])
        flash[:notice] = 'Blog::Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.xml
  def destroy
    @post = Blog::Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(blog_posts_url) }
      format.xml  { head :ok }
    end
  end
end
