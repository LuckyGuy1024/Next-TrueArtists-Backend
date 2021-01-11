# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions do
    collection do
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
    end
  end

  resources :users
  resources :artists, only: [:index, :show]
  resources :studios, only: [:index, :show]
  resources :tattoos, only: [:index, :show]
  resources :articles
end
