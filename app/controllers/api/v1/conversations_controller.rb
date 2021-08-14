class Api::V1::ConversationsController < ApplicationController
  def index
    @conversations = paginate(Conversation.where(sender_id: current_user.id)
                                          .or(receiver_id: current_user.id))
    render json: ActiveModel::Serializer::CollectionSerializer.new(@conversations,
                                                                   serializer: ConversationSerializer),
           status: :ok
  end

  def show
    @conversations = Conversation.where(id: params[:id])
                                 .where(sender_id: current_user.id)
                                 .or(Conversation.where(receiver_id: current_user.id)).first
  end
end
