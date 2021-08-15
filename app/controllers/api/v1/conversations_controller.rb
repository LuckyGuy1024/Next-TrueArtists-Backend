class Api::V1::ConversationsController < ApplicationController
  def index
    @conversations = paginate(Conversation.where(sender_id: current_user.id)
                                          .or(receiver_id: current_user.id))
    render json: ActiveModel::Serializer::CollectionSerializer.new(@conversations,
                                                                   serializer: ConversationSerializer),
           status: :ok
  end

  def show
    @conversation = Conversation.where(id: params[:id])
                                .where(sender_id: current_user.id)
                                .or(Conversation.where(receiver_id: current_user.id)).first
  end

  def archive
    if @conversation.archive!
      head(:ok)
    else
      render_api_error(status: 422, errors: @conversation.errors)
    end
  end

  def read
    if @conversation.read!
      head(:ok)
    else
      render_api_error(status: 422, errors: @conversation.errors)
    end
  end

  private

  def conversation
    @conversation = Conversation.where(id: params[:id])
                                .where(sender_id: current_user.id)
                                .or(Conversation.where(receiver_id: current_user.id)).first
    head(:not_found) unless @conversation
  end
end
