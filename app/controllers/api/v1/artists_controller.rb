# frozen_string_literal: true

class Api::V1::ArtistsController < ApplicationController
  before_action :find_artist, except: %i[create index]

  def index
    @artists = paginate(Artist.all)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@artists,
                                                                   serializer: ArtistSerializer),
           status: :ok
  end

  def show
    render json: ArtistSerializer.new(@artist).to_json, status: :ok
  end

  def create
    artist = Artist.new(artist_params)
    artist.user_id = @current_user&.id

    if artist.save
      render json: ArtistSerializer.new(artist).to_json, status: :created
    else
      render_api_error(status: 422, errors: artist.errors)
    end
  end

  def update
    if @artist.update(artist_params)
      render json: ArtistSerializer.new(@artist).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @artist.errors)
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
      :attachments_attributes: [:image]
    )
  end
end
