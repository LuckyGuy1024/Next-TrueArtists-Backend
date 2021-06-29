# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController

      def create
        message = Message.build_message(current_user, message_params)

        if message.save
          render json: message.to_json, status: :created
        else
          render_api_error(status: 422, errors: message.errors)
        end
      end

      private

      def message_params
        params.permit(
          :content,
          :recipient_type,
          :recipient_id,
          :thread_id
        )
      end
    end
  end
end
