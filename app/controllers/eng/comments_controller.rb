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
    @comment = @article.comments.build(eng_comment_params)
    @comment.author_ip = request.remote_ip

    respond_to do |format|
      #if verify_recaptcha(:model => @comment) && @comment.save
      if @comment.save
        if @comment.spam_status =~ /spam\Z/
          flash[:notice] = 'Your comment has been marked as spam, so it will not appear. Email me to resolve this.'
        else
          Eng::CommentNotifier.new_comment(@comment).deliver
          flash[:notice] = 'Thank you for your comment.'
        end
        format.html { redirect_to(@article) }
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
      flash[:notice] = 'Comment is now spam'
      redirect_to(article)
    end
  end

  def ham
    @comment = comment
    @comment.ham!

    if @comment.save
      flash[:notice] = 'Comment is now ham'
      redirect_to(article)
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

  private

  def eng_comment_params
    params.require(:eng_comment).permit(:author_name, :author_website, :author_email, :body)
  end

  def article
    @_article ||= Eng::Article.find(params[:article_id])
  end

  def comment
    @_comment ||= Eng::Comment.find(params[:id])
  end
end
