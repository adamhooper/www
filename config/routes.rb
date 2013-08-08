Www::Application.routes.draw do
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

  # Support old "/code" URLs, because people still use them.
  get '/code', to: redirect('https://github.com/adamhooper/code-from-adamhoopers-school-days')
  # We don't know if the requested URL is for a blob or a tree, so pick
  # GitHub's "tree" URL. If the requested URL is actually a blob, GitHub
  # will helpfully redirect to the parent
  get '/code/*path', to: redirect("https://github.com/adamhooper/code-from-adamhoopers-school-days/tree/master/%{path}")

  root :to => 'about#index'
end
