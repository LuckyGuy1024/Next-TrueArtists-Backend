# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController

      def create
        message = Message.build_message(current_user, message_params, receiver_id)

        if message.save
          render json: message.to_json, status: :created
        else
          render_api_error(status: 422, errors: message.errors)
        end
      end

      private

      def receiver_id
        recipient = message_params[:recipient_type].constantize.find(message_params[:recipient_id])

        if recipient.instance_of?(Studio) || recipient.instance_of?(Artist)
          recipient.user_id
        else
          recipient.id
        end
      end

      def message_params
        params.permit(
          :description,
          :placement,
          :size,
          :urgency,
          :first_time,
          :recipient_type,
          :recipient_id,
          :thread_id
        )
      end
    end
  end
end
