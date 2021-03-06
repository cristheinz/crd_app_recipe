CrdAppRecipe::Application.routes.draw do
  get "feedbacks/create"

  #get "password_resets/new"

  resources :categories

  resources :sources

  resources :portions

  resources :ingredients

  resources :recipes, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  #match 'recipes/:name' => 'recipes#show'

  resources :users
  resources :password_resets

  resources :usersbooks, only: [:create, :destroy]
  resources :usersmarks, only: [:create, :index, :set]
  match '/setitem',  to: 'usersmarks#set'
  resources :feedbacks, only: [:create]

  resources :sessions, only: [:new, :create, :destroy]
  match '/about',  to: 'static_pages#about'
  match '/partnership',  to: 'static_pages#partnership'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/welcome',  to: 'sources#index'

  resources :assignments, only: [:new, :create, :destroy]
  match '/assignout', to: 'assignments#destroy', via: :delete
  match '/remove', to: 'assignments#remove', via: :delete

  
  match '/:locale', to: 'static_pages#home'
  root to: 'static_pages#home'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
