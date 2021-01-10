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

  resources :suppliers do
    resources :data_sources
  end

  resources :products do
    collection do
      get 'product_schema' => 'products#product_schema'
    end
  end
end
