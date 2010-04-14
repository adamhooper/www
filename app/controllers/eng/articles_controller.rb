class Eng::ArticlesController < ApplicationController
  before_filter :authorize, :except => [ :index, :show ]

  make_resourceful do
    actions :all

    before(:show) do
      @new_comment = @article.comments.build(:author_ip => request.remote_ip)
    end

    response_for :index do |format|
      format.html
      format.rss do
        if params[:fb] || params[:page]
          render :layout => false
        else
          # FIXME: Do not call current_objects when we're using FeedBurner
          redirect_to 'http://feeds2.feedburner.com/AdamHoopersEngineeringTips'
        end
      end
    end
  end

  def current_objects
    @current_objects ||= Eng::Article.order('eng_articles.created_at DESC').paginate(
      :per_page => 25,
      :page => params[:page]
    )
  end

  def current_model
    Eng::Article
  end
end
