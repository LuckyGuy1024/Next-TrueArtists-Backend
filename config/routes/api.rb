# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :sessions do
        collection do
          post 'login' => 'sessions#create'
          delete 'logout' => 'sessions#destroy'
        end
      end

      get 'me' => 'users#show'
      resources :users, only: %i[create show update destroy]

      # update and change passwords
      match '/passwords/change_password', to: 'passwords#update', via: :put
      match '/passwords', to: 'passwords#create', via: :post

      resources :artists do
        resources :tattoos
        resources :clients

        member do
          get :studios
        end

        collection do
          put 'verify-phone' => 'studios#verify_phone'
        end

        member do
          get :artists
          delete 'delete-image/:image_id' => 'artists#remove_image'
          put :submit_for_review
          get 'studio_invites' => 'artists#studio_invites'
        end
      end

      resources :studios do
        resources :tattoos
        resources :clients

        collection do
          put 'verify-phone' => 'studios#verify_phone'
        end

        member do
          get :artists
          delete 'delete-image/:image_id' => 'studios#remove_image'
          delete 'studio_artists/:studio_artist_id' => 'studios#remove_studio_artist'
          post 'invite_artist' => 'studios#invite_artist'
          put :submit_for_review
          get :guest_artist_applications
          get 'guest_artist_applications/:id' => 'studios#application'
          get 'studio_invites' => 'studios#studio_invites'
        end
      end

      resources :locations, only: %i[index show]

      resources :studio_invites, path: 'studio-invites' do
        collection do
          post 'invite-artist/:id' => 'studio_invites#create'
          get 'accept-invite' => 'studio_invites#accept_studio_invite'
        end

        member do
          put 'accept-invite' => 'studio_invites#accept_studio_invite'
          put 'reject-invite' => 'studio_invites#reject_studio_invite'
          put 'cancel-invite' => 'studio_invites#cancel_studio_invite'
        end
      end

      resources :favorites, only: %i[create] do
        collection do
          :delete
        end
      end

      resources :tattoos, only: %i[index show update] do
        collection do
          post 'batch-create' => 'tattoos#batch_create'
          get 'filter' => 'tattoos#filter'
        end
        member do
          put :flag
        end
      end

      resources :conventions do
        member do
          put :submit_for_review
        end
      end

      resources :articles, only: %i[index show]
      resources :styles
      resources :categories, only: %i[index show]
      resources :landing_pages, only: %i[show index]

      resources :conversations, only: %i[index] do
        member do
          put :archive
          put :read
        end
      end
      resources :messages, only: %i[create]

      resources :bookings

      resources :guest_artist_applications, only: %i[create update destroy] do
        member do
          post :respond
        end
      end
    end
  end
end
