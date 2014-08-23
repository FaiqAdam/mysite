Rails.application.routes.draw do
  devise_for :users
  get 'home/index'

  resources :reports

  root 'home#index'


end
