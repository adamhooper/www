class Blog::CommentsController < ApplicationController
  layout 'hooper'
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
