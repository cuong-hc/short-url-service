Rails.application.routes.draw do  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api, defaults: { format: :json } do
    post "encode" => "shortener_url#encode"
    post "decode" => "shortener_url#decode"
  end
end
