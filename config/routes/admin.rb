# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :users
        resources :passwords do
          collection do
            put 'change_password' => 'passwords#update'
          end
        end
        resources :artists do
          resources :tattoos
          member do
            delete 'delete-image/:image_id' => 'artists#remove_image'
          end
        end
        resources :studios do
          resources :tattoos
          member do
            delete 'delete-image/:image_id' => 'studios#remove_image'
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
        end
        resources :articles
      end
    end
  end
end
