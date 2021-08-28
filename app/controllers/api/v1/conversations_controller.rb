class Api::V1::ConversationsController < ApplicationController
  before_action :find_conversation, except: [:index]
  def index
    @conversations = paginate(current_user_conversations)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@conversations,
                                                                   serializer: ConversationSerializer),
           status: :ok
  end

  def show
    render json: ConversationSerializer.new(@conversation).to_json, status: :ok
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

  def current_user_conversations
    @current_user_conversations = Conversation.where(sender_id: current_user.id)
                                              .or(Conversation.where(receiver_id: current_user.id))
                                              .order("updated_at DESC")
  end

  def find_conversation
    @conversation = current_user_conversations.find(params[:id])
    head(:not_found) unless @conversation
  end
end
