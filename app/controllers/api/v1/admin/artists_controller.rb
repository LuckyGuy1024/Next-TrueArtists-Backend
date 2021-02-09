# frozen_string_literal: true

module Api::V1::Admin
  class ArtistsController < AdminController
    before_action :find_artist, except: %i[index create accept_artist_invite]

    def index
      @artists = Artist.paginate(page: params[:page], per_page: 10)
      render json: ActiveModel::Serializer::CollectionSerializer.new(@artists,
                                                                     serializer: ArtistSerializer),
             status: :ok
    end

    def show
      render json: ArtistSerializer.new(@artist).to_json, status: :ok
    end

    def update
      artist = ArtistForm.new(@artist, artist_params).update
      if artist
        render json: ArtistSerializer.new(@artist).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def remove_image
      attachment = ActiveStorage::Attachment.find(params[:image_id]).purge
      if attachment.blank?
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    private

    def find_artist
      @artist = Artist.find(params[:id])
    end

    def artist_params
      params.permit(
        :user_id,
        :slug,
        :licensed,
        :years_of_experience,
        :styles,
        :website,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :phone_number,
        :minimum_spend,
        :price_per_hour,
        :currency_code,
        :street_address,
        :city,
        :state,
        :zip_code,
        :country,
        :seeking_guest_spot,
        :guest_artist,
        :avatar,
        :hero_banner
      )
    end
  end
end
