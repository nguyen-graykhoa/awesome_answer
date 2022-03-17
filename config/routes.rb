Rails.application.routes.draw do
  root "welcome#index"
  get 'answers/index'
  get 'answers/new'
  get 'answers/show'
  get 'answers/delete'
  get 'users/edit_password', to: 'users#edit_password'
 
 
  resource :sessions, only: [:new, :destroy, :create] 
  
  resources :users do
    get 'edit_password', to: 'users#edit_password', as: 'edit_password'
    patch 'update_password', to: 'users#update_password', as: 'update_password'
  end

  resources :questions do
     resources :answers, only: [:create, :destroy]
     resources :likes, shallow: true, only: [:create, :destroy]
     get :liked, on: :collection
  end
  
 #Contacts:
  get 'contacts/new', to: 'contacts#new', as: 'contacts_new'
  post 'thank_you', to: 'contacts#create'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   

  # When people type "localhost:3000" 
  # it sends a http get request to this path "localhost:3000", 
  # which is rails' default server when running "rails s"
  # The http get request will be handled by the "WelcomeController" in the "index" action
  
  # get('/', {to: 'welcome#index'})
  #root "welcome#index" #root can be used to indicated the default root page, same as the request above
  get('/welcome', {to: 'welcome#index'})
  get('/goodbye', {to: 'welcome#goodbye', as: :what}) #:as option give you the ability to give an alias to a specific path
  # when directing a route in a view page, you give it a path to access the route: 
  #(see views/layouts/application.html.erb for the navigation paths as examples)
  # goodbye_url => http://localhost:3000/goodbye
  # goodbye path: what_path => /goodbye
  
  get('/form_example', {to: 'welcome#form_example'})
  resources :job_posts, only: [:new, :create, :show, :index, :destroy, :edit, :update]
end
