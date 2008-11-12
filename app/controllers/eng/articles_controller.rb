class Eng::ArticlesController < ApplicationController
  before_filter :authorize, :except => [ :index, :show ]

  make_resourceful do
    actions :all

    before(:show) do
      @new_comment = @article.comments.build(:author_ip => request.remote_ip)
    end

    response_for :index do |format|
      format.html
      format.rss
    end
  end

  def current_objects
    @current_objects ||= Eng::Article.paginate(
      :per_page => 25,
      :page => params[:page],
      :order => 'eng_articles.created_at DESC'
    )
  end

  def current_model
    Eng::Article
  end
end
