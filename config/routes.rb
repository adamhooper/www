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

  get '/blog(/:tag)(/index).rss20' => 'blog/posts#index', :format => 'rss'
  get '/blog(/:tag)(/index)(.:format)' => 'blog/posts#index', :as => 'blog'
  get '/eng' => 'eng/articles#index', :as => 'eng'

  root :to => 'about#index'
end
