Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: %i{index show}
  resources :stores, only: %i{index show}
  resources :sales_channels, only: %i{index show}
  resources :orders, only: %i{index show}
  resources :items, only: %i{index show}
  resources :item_variations, only: %i{index show}
  resources :item_images, only: %i{index show}
  resources :inventory_units, only: %i{index show}
  resources :customers, only: %i{index show}
  resources :customer_addresses, only: %i{index show}
end
