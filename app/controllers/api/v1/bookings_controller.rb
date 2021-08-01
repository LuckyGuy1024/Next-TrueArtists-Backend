# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      before_action :find_or_create_user, only: %i[create]

      def create
        booking = Booking.build_booking(@user, booking_params)

        if booking.save
          render json: BookingSerializer.new(booking).to_json, status: :created
        else
          render_api_error(status: 422, errors: booking.errors)
        end
      end

      private

      def find_or_create_user
        existing_user = User.where(email: booking_params[:email]).first

        begin
          user = if current_user.nil? && existing_user.nil?
                   User.create!(
                     full_name: booking_params[:email],
                     email: booking_params[:email],
                     password: 'MyName1993',
                     password_confirmation: 'MyName1993'
                   )
                 else
                   existing_user
                 end

          @user = current_user.nil? ? user : current_user
        rescue StandardError => e
          render json: { errors: e.message }
        end
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
    end
  end
end
