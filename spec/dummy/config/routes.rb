Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Defines the root path route ("/")
  root "home#show"

  # Multiple widgets on the same page, to test script-deduplication behaviour.
  get '/multiple', to: 'home#multiple'

  # Allows another route, to test Turbo navigation.
  get "/*p", to: "home#show"
  post '/*p', to: "home#submit"
end
