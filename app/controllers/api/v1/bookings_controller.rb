# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      skip_before_action :authenticate_request!, only: %i[create]
      before_action :find_booking, only: %i[show cancel accept archive reject]
      before_action :find_booking_user, only: %i[create]

      def index
        @results = BookingSearch.new(
          query: params[:query],
          options: search_options
        ).filter

        render json: @results, status: :ok
      end

      def create
        result = BookingService.new(booking_params).call

        if result && result.success?
          render json: BookingSerializer.new(result.payload).to_json, status: :created
        else
          render_api_error(status: 422, errors: result.errors)
        end
      end

      def reject
        authorize @booking, :accept?
        @booking.reject!
        head(:ok)
      end

      def accept
        authorize @booking, :accept?
        @booking.accept!
        head(:ok)
      end

      def archive
        authorize @booking, :archive?
        @booking.archive!
        head(:ok)
      end

      def cancel
        authorize @booking, :cancel?
        @booking.cancel!
        head(:ok)
      end

      def show
        authorize @booking

        render json: BookingSerializer.new(@booking).to_json, status: :ok
      end

      private

      def find_booking_user
        return current_user if current_user
        result = UserService.new(user_params).call
        return result.payload if result && result.success?

        render_api_error(status: 422, errors: result.errors)
      end

      def find_booking
        @booking = Booking.find(params[:id])
      end

      def booking_params
        params.permit(
          :description,
          :tattoo_placement,
          :tattoo_color,
          :tattoo_size,
          :budget,
          :style_id,
          :formatted_address,
          :phone_number,
          :availability,
          :formatted_address,
          :urgency,
          :bookable_type,
          :bookable_id,
          :first_tattoo,
        ).tap do |booking|
          booking[:user_id] = find_booking_user.id
        end
      end

      def booking_image_params
        params.permit(:images).each do |image|
          booking.image.attach(io: image)
        end
      end

      def user_params
        params.permit(:full_name, :email, :formatted_address).tap do |user|
          user[:autogenerated] = true
        end
      end

      def search_options
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || BaseSearch::PER_PAGE,
          status: params[:status],
          email: params[:email],
          phone_number: params[:phone_number],
          user: current_user
        }.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
