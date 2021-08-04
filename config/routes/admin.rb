# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :users

        resources :passwords, only: %i[create]

        resources :artists do
          resources :tattoos
          collection do
            put 'reject-image/:image_id' => 'artists#reject_image'
          end
          member do
            delete 'delete-image/:image_id' => 'artists#remove_image'
            get 'studio_invites' => 'artists#studio_invites'
            put :approve
            put :reject
          end
        end
        resources :studios do
          resources :tattoos
          collection do
            put 'reject-image/:image_id' => 'studios#reject_image'
          end
          member do
            delete 'delete-image/:image_id' => 'studios#remove_image'
            post 'invite_artist' => 'studios#invite_artist'
            get 'studio_invites' => 'studios#studio_invites'
            put :approve
            put :reject
          end
        end

        resources :landing_pages do
          member do
            delete 'delete-image/:image_id' => 'landing_pages#remove_image'
          end
        end

        resources :locations do
          member do
            delete 'delete-image/:image_id' => 'locations#remove_image'
          end
        end

        resources :studio_invites, path: 'studio-invites' do
          collection do
            post 'invite-artist/:id' => 'studio_invites#create'
          end
        end

        resources :tattoos, only: %i[index show] do
          collection do
            post 'batch-create' => 'tattoos#batch_create'
          end
          member do
            put :flag
            put :approve
          end
        end

        resources :conventions do
          member do
            put :approve
            put :reject
            put :submit_for_review
          end
        end

        resources :announcements do
          member do
            put :publish
          end
        end

        resources :articles
        resources :pages
        resources :styles
        resources :categories
        resources :guest_artist_applications
        resources :dashboard, only: %i[index]
      end
    end
  end
end
