# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      skip_before_action :authenticate_request!, only: %i[create]
      before_action :find_booking, only: %i[show]
      before_action :find_or_create_user, only: %i[create]

      def index
        @results = BookingSearch.new(
          query: params[:query],
          options: search_options
        ).filter

        render json: @results, status: :ok
      end

      def create
        booking = Booking.build_booking(@user, booking_params)

        if booking.save
          render json: BookingSerializer.new(booking).to_json, status: :created
        else
          render_api_error(status: 422, errors: booking.errors)
        end
      end

      def show
        authorize @booking

        render json: BookingSerializer.new(@booking).to_json, status: :ok
      end

      private

      def find_or_create_user
        existing_user = current_user.nil? ? User.where(email: booking_params[:email]).first : current_user

        begin
          @user = if existing_user.nil?
                    password = "TA#{Array.new(11) { rand(9) }.join}"

                    new_user = User.new(
                      full_name: booking_params[:email],
                      email: booking_params[:email],
                      password: password,
                      password_confirmation: password
                    )

                    new_user.send_new_user_invitation if new_user.save
                  else
                    existing_user
                  end

        rescue StandardError => e
          render json: { errors: e.message }
        end
      end

      def find_booking
        @booking = Booking.find(params[:id])
      end

      def booking_params
        params.permit(
          :full_name,
          :email,
          :description,
          :placement,
          :urgency,
          :consult_artist,
          :first_tattoo,
          :size_units,
          :colored,
          :recipient_type,
          :recipient_id,
          :custom_size
        )
      end

      def search_options
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || BaseSearch::PER_PAGE,
          status: params[:status],
          user_id: current_user.id,
          near: params[:city] || params[:near],
          within: params[:within]
        }.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
