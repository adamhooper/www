Www::Application.routes.draw do
  resource :code, :controller => 'code' do
    get :data
    get :download
  end

  resources :sessions

  namespace :blog do
    resources :posts do
      resources :comments do
        post 'spam', :on => :member
        post 'ham', :on => :member
      end
    end
  end

  namespace :eng do
    resources :articles do
      resources :comments do
        post 'spam', :on => :member
        post 'ham', :on => :member
      end
    end
  end

  match '/blog(/:tag)(/index).rss20' => 'Blog::Posts#index', :format => 'rss'
  match '/blog(/:tag)(/index)(.:format)' => 'Blog::Posts#index', :as => 'blog'
  match '/eng' => 'Eng::Articles#index', :as => 'eng'

  root :to => 'about#index'
end
