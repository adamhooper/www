ActionController::Routing::Routes.draw do |map|
  map.resource :code, :controller => 'Code', :member => {
    :data => :get,
    :download => :get
  }
  map.resources :sessions

  map.namespace :blog do |blog|
    blog.resources :posts do |post|
      post.resources :comments
    end
  end

  map.namespace :eng do |eng|
    eng.resources :articles do |article|
      article.resources :comments
    end
  end

  map.root_static_actions :about, [:index ]

  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'

  map.connect '/blog/index.rss20', :controller => 'Blog::Posts', :format => 'rss'
  map.connect '/blog/:tag/index.rss20', :controller => 'Blog::Posts', :format => 'rss'
  map.connect '/blog/index.:format', :controller => 'Blog::Posts'
  map.connect '/blog/:tag/index.:format', :controller => 'Blog::Posts'

  map.blog '/blog', :controller => 'blog/posts'
  map.eng '/eng', :controller => 'eng/articles'

  map.connect '/blog/:tag', :controller => 'Blog::Posts'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
