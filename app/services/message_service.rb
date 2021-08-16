class MessageService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    message = Message.new(
      content: Message::DEFAULT_BOOKING_MESSAGE,
      sender_id: params[:sender_id],
      receiver_id: params[:receiver_id],
      conversation_id: params[:conversation_id]
    )
    message.message_type = Message.message_types[:appointment]

    if message.save
      OpenStruct.new({ success?: true, payload: message })
    else
      OpenStruct.new({ success?: false, errors: message.errors.full_messages })
    end
  end
end
