ActionController::Routing::Routes.draw do |map|
  map.resources :sessions

  map.namespace :blog do |blog|
    blog.resources :posts do |post|
      post.resources :comments
    end
  end

  map.root_static_actions :about, [:index, :photos]

  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'

  map.blog '/blog', :controller => 'blog/posts'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
