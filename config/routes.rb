Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :order_manufacturings
  resources :payrolls
  resources :items
end
