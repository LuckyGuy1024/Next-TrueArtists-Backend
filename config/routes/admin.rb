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
            put :approve
            put :reject
          end
        end
        resources :locations do
          member do
            delete 'delete-image/:image_id' => 'locations#remove_image'
          end
        end

        resources :studio_invites, path: 'studio-invites' do
          collection do
            post 'invite-artist' => 'studio_invites#create'
          end
        end

        resources :tattoos, only: %i[index show] do
          collection do
            post 'batch-create' => 'tattoos#batch_create'
          end
          member do
            put :flag
          end
        end
        resources :articles
        resources :landing_pages
        resources :styles
        resources :categories
        resources :guest_artist_applications
      end
    end
  end
end
