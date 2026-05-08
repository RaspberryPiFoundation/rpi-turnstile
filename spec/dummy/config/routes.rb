Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Defines the root path route ("/")
  root "home#show"

  # Allows another route, to test Turbo navigation.
  get "/*p", to: "home#show"
  post '/*p', to: "home#submit"
end
