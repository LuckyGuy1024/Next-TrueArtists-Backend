# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      before_action :find_or_create_user, only: %i[create]

      def create
        booking = Booking.build_booking(@user, booking_params)

        if booking.save
          render json: booking.to_json, status: :created
        else
          render_api_error(status: 422, errors: booking.errors)
        end
      end

      private

      def find_or_create_user
        user = if current_user.nil? && User.find_by!(email: booking_params[:email]).nil?
                 User.create!(full_name: booking_params[:email], email: booking_params[:email], password: 'MyName1993',
                              password_confirmation: 'MyName1993')
               else
                 User.find_by!(email: booking_params[:email])
               end

        @user = current_user.nil? ? user : current_user
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
