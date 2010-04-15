Www::Application.routes.draw do
  resource :code, :controller => 'code' do
    get :data
    get :download
  end

  resources :sessions

  namespace :blog do
    resources :posts do
      resources :comments
    end
  end

  namespace :eng do
    resources :articles do
      resources :comments
    end
  end

  match '/captcha' => 'simple_captcha#simple_captcha', :as => 'simple_captcha', :format => :jpg

  match '/blog(/:tag)(/index).rss20' => 'Blog::Posts#index', :format => 'rss'
  match '/blog(/:tag)(/index)(.:format)' => 'Blog::Posts#index', :as => 'blog'
  match '/eng' => 'Eng::Articles#index', :as => 'eng'

  root :to => 'about#index'
end
