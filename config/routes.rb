ActionController::Routing::Routes.draw do |map|
  map.namespace :blog do |blog|
    blog.resources :posts
  end

  map.root_static_actions :about, [:index, :photos]

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
