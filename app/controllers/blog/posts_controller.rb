class Blog::PostsController < ApplicationController
  before_filter :authorize, :except => [ :index, :show ]

  make_resourceful do
    actions :all

    before :show do
      @new_comment = @post.comments.build(:author_ip => request.remote_ip)
    end

    response_for :index do |format|
      format.html
      format.rss do
        if params[:fb] || params[:tag] || params[:page]
          render :layout => false
        else
          # FIXME: Do not call current_objects when we're using FeedBurner
          redirect_to 'http://feeds2.feedburner.com/adamhooper'
        end
      end
    end
  end

  def current_objects
    @current_objects ||= Blog::Post.with_tag(params[:tag]).paginate(
      :per_page => 10,
      :page => params[:page],
      :order => 'blog_posts.created_at DESC'
    )
  end

  def current_model
    Blog::Post
  end
end
