SwellMedia::Engine.routes.draw do
	root to: 'static#home' # set media to HP if null id

	resources :admin, only: :index


	resources :articles, path: SwellMedia.article_path
	resources :article_admin, path: 'blog_admin' do
		get :preview, on: :member
		delete :empty_trash, on: :collection 
	end

	resources :asset_manager, only: [ :new, :create, :destroy ] do
		post :callback_create, on: :collection
		get :callback_create, on: :collection
	end

	resources :asset_admin do
		delete :empty_trash, on: :collection 
	end

	resources :browse

	resources :category_admin

	resources :contacts do 	
		get :thanks, on: :collection
	end
	resources :contact_admin do
		post :import, on: :collection
		get :export, on: :collection
	end

	resources :lead_offers, path: 'get' do 
		get :accept, on: :member
	end

	resources :lead_offer_admin

	resources :media_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection 
	end

	resources :optins do 	
		get :thank_you, on: :member, path: 'thank-you'
	end

	resources :page_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection 
	end

	resources :user_admin

	resources :imports
	resources :exports

	get 'console' => 'static#console'
	

	#resources :sessions

	devise_scope :user do
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		put '/check_name' => 'registrations#check_name', as: 'check_name'
	end
	#devise_for :users, :controllers => { :omniauth_callbacks => 'swell_media/oauth', :registrations => 'swell_media/registrations', :sessions => 'swell_media/sessions', :passwords => 'swell_media/passwords' }

	get '/privacy', to: 'static#privacy', as: :privacy
	get '/terms', to: 'static#terms', as: :terms

	# quick catch-all route for static pages
	# set root route to field any media
	get '/:id', to: 'root#show', as: 'root_show'

end
