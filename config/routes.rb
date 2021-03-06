Etl::Application.routes.draw do
  get "misc/index"

  resources :import do
	  collection do
      post :new_web, :new_phone
	  end 
	end

  resources :export do
	  collection do
      post :download, :upload
	  end 
	end

  resources :loupan do
	  collection do
      get :add, :delete, :add_output, :list
	  end 
	end

  resources :misc do
	  collection do
      get :fetch
      post :upload
	  end 
	end
	
	resources :fdt do
	  collection do
      get :index, :add_csv, :assign_id, :channels, :del_channel, :edit_channel, :add_channel, :loupan
      post :add_csv, :upload, :assign_id, :edit_channel
	  end 
	end
		

  match 'loupan/delete/:id' => 'loupan#delete'
  match 'loupan/add_output/:id' => 'loupan#add_output'
  match 'fdt/assign_id/:id' => 'fdt#assign_id'
  match 'fdt/del_channel/:id' => 'fdt#del_channel'
  match 'fdt/edit_channel/:id' => 'fdt#edit_channel'

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
  root :to => 'misc#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
