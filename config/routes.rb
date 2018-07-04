Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # LEGACY SERVER ENDPOINT
  #
  # Skins are retrieved by a combination of type and player uuid
  get ':type/:uuid.png' => 'legacy#show'
  
  # VALHALLA SERVER ENDPOINT
  #
  # Relevant data including texture urls, models, and types
  # are retrieved as json
  get 'profile/:uuid' => 'profiles#show'
  
  # Extra stuff
  #
  # Previous textures are stored and kept up to 30 days.
  # You can get them out using this endpoint.
  resources :texture, only: [:index, :update]
  
  # Skins can be uploaded via either post of put
  scope controller: :profiles, action: :gateway do
    post '/'
    put '/'
  end
  
  get 'about' => 'welcome#about'
  
  root 'welcome#index'
end
