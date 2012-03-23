class Eng::CommentsController < Eng::BaseController
  before_filter :authorize, :except => [ :new, :create ]

  def new
    @article = Eng::Article.find(params[:article_id])
    @comment = @article.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # POST /blog_comments
  # POST /blog_comments.xml
  def create
    @article = Eng::Article.find(params[:article_id])
    @comment = @article.comments.build(params[:eng_comment].merge(:author_ip => request.remote_ip))

    respond_to do |format|
      if verify_recaptcha(:model => @comment) && @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    article = Eng::Article.find(params[:article_id])
    comment = Eng::Comment.find(params[:id])

    comment.destroy
    flash[:notice] = 'Comment was destroyed'

    respond_to do |format|
      format.html { redirect_to(article) }
      format.xml { head :ok }
    end
  end
end
