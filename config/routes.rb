Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :users do
    collection do
      get :get_or_create
    end
    member do
      get :positions
      get :mentors
      post :add_skills
    end
  end

  resources :darshans
  resources :medias
  resources :announcements

  resources :sadhna_cards do
    collection do
      get :download
    end
  end

  scope '/recommender' do
    resources :recommendations do
      collection do
        get :run
        get :run_new
        get :show_recs
      end
    end
  end

  resources :benchmark

  resources :skills

  get 'sessions/new'

  get 'users/new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get    'logout'  => 'sessions#destroy'

  resources :users

  # You can have the root of your site routed with "root"
  root 'sadhna_cards#index'

  post    'update_rounds'  => 'users#update_rounds'
  get    '/users/:id/report'  => 'users#report'
  get '/users_account' => 'users#edit'

  post '/storeauthcode' => 'sessions#sign_in'

  get '/badges' => 'users#badges'
  get '/badges/:id' => 'users#badges'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
