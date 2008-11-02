class Eng::ArticlesController < ApplicationController
  before_filter :authorize, :except => [ :index, :show ]

  make_resourceful do
    actions :all

    response_for :index do |format|
      format.html
      format.rss
    end
  end

  def current_objects
    @current_objects ||= Eng::Article.all.paginate(
      :per_page => 25,
      :page => params[:page],
      :order => 'eng_articles.created_at DESC'
    )
  end

  def current_model
    Eng::Article
  end
end
