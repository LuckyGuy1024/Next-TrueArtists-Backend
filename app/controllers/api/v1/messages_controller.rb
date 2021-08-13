# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      def create
        message = Message.new(message_params)

        if message.save
          render json: message.to_json, status: :created
        else
          render_api_error(status: 422, errors: message.errors)
        end
      end

      def threads
        messages = Message.where(sender_id: current_user.id)
                          .or(Message.where(receiver_id: current_user.id))

        render json: messages, status: :ok
      end

      def thread_messages
        messages = Message.where(thread_id: params[:thread_id])

        render json: messages, status: :ok
      end

      private

      def message_params
        params.permit(
          :content,
          :receiver_id,
          :is_read,
          :message_type,
          :thread_id
        ).tap do |message|
          message[:sender_id] = current_user.id
        end
      end
    end
  end
end
