class Eng::ArticlesController < Eng::BaseController
  before_filter :authorize, :except => [ :index, :show ]

  def index
    respond_to do |format|
      format.html do
        @articles = current_articles
      end
      format.rss do
        if params[:fb] || params[:tag] || params[:page]
          @articles = current_articles
          render :layout => false
        else
          redirect_to 'http://feeds2.feedburner.com/adamhooper'
        end
      end
    end
  end

  def show
    @article = current_article
    @comments = current_visible_comments
    @new_comment = @article.comments.build(:author_ip => request.remote_ip)
  end

  def new
    @article = Eng::Article.new
  end

  def edit
    @article = current_article
  end

  def create
    @article = Eng::Article.new(params[:eng_article])
    if @article.save
      redirect_to([:eng, @article], :notice => 'Eng article created')
    else
      render(:new)
    end
  end

  def update
    @article = current_article
    if @article.update_attributes(params[:eng_article])
      redirect_to([:eng, @article], :notice => 'Eng article updated')
    else
      render(:edit)
    end
  end

  def destroy
    current_article.destroy
    redirect_to([:eng, :index], :notice => 'Eng article destroyed')
  end

  private

  def current_visible_comments
    if admin? && params[:spam]
      current_article.comments
    else
      current_article.comments.hammy
    end
  end

  def current_articles
    Eng::Article
      .order('eng_articles.created_at DESC')
      .paginate(:per_page => 20, :page => params[:page])
  end

  def current_article
    @_current_article ||= Eng::Article.find(params[:id])
  end
end
