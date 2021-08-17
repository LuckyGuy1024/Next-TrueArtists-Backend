class BookingService
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def call
    return handle_error(['Select a studio or artist']) unless recipient

    return handle_error(conversation.errors) unless conversation.success?

    message = MessageService.new(
      receiver_id: recipient&.id,
      conversation_id: conversation.payload.id,
      sender_id: params[:user_id]
    ).call

    if message && message.success?
      booking = Booking.new(params)
      booking.bookable = bookable
      booking.conversation_id = message.payload.conversation_id
      if booking.save
        OpenStruct.new({ success?: true, payload: booking })
      else
        handle_error(booking.errors.full_messages)
      end
    else
      handle_error(message&.errors)
    end
  end

  private

  def conversation
    conversation_service = ConversationService.new(
      receiver_id: recipient&.id,
      sender_id: params[:user_id]
    ).call
  end

  def recipient
    @recipient ||= bookable&.user
  end

  def bookable
    @bookable ||= params[:bookable_type].constantize.find_by(slug: params[:bookable_id])
  end

  def handle_error(error)
    OpenStruct.new({ success?: false, errors: error })
  end
end
