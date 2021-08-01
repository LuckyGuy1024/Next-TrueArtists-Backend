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

      def get_threads
        threads = Message.threads

        user_thread_messages = threads.filter_map do |thread|
          Message.where(sender_id: current_user.id,
                        thread_id: thread).or(Message.where(receiver_id: current_user.id, thread_id: thread)).first
        end

        render json: user_thread_messages, status: :ok
      end

      def get_thread_messages
        messages = Message.where(thread_id: params[:thread_id])

        render json: messages, status: :ok
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
