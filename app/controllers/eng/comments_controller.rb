class Eng::CommentsController < ApplicationController
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

    captcha_valid = simple_captcha_valid?

    respond_to do |format|
      if captcha_valid && @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@article) }
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
