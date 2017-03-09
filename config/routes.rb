Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :order_manufacturings
  resources :payrolls
  resources :items
  resources :jobs
  resources :workers
  resources :counterparties
  post 'add_item_detail' => 'items#add_item_detail'
end
