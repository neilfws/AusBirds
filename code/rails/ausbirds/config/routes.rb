Ausbirds::Application.routes.draw do
  root :to => "home#index"
  get "species/index"
end
