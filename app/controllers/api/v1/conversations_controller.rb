class Api::V1::ConversationsController < ApplicationController
  before_action :find_conversation, except: [:index]
  def index
    @conversations = paginate(current_user_conversations)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@conversations,
                                                                   serializer: ConversationSerializer,
                                                                   current_user: current_user),
           status: :ok
  end

  def show
    render json: ConversationSerializer.new(@conversation).to_json,
           current_user: current_user,
           status: :ok
  end

  def archive
    if @conversation.mark_as_archived(current_user)
      head(:ok)
    else
      render_api_error(status: 422, errors: @conversation.errors)
    end
  end

  def read
    if @conversation.mark_as_read(current_user)
      head(:ok)
    else
      render_api_error(status: 422, errors: @conversation.errors)
    end
  end

  private

  def current_user_conversations
    # @current_user_conversations = ConversationReceiptSearch.new(
    #   query: params[:query],
    #   options: search_options
    # ).filter
    @current_user_conversations = if params[:archived]
                                    Conversation.archived(current_user)
                                  else
                                    Conversation.for_receiver(current_user)
                                  end
  end

  def search_options
    {
      receiver_id: current_user.id,
      read: params[:read],
      archived: params[:archived] || false,
      deleted: params[:deleted] || false
    }
  end

  def find_conversation
    @conversation = current_user_conversations.find(params[:id])
    head(:not_found) unless @conversation
  end
end
