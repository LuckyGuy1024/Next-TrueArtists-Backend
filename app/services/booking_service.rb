class BookingService
  attr_accessor :params

  def initialize(params = {})
    @params = params
  end

  def call
    return handle_error('Select a studio or artist') unless recipient

    message = MessageService.new(
      message_id: params[:message_id],
      receiver_id: recipient&.id,
      sender_id: params[:user_id]
    ).call

    if message && message.success?
      booking = Booking.new(params)
      booking.message_id = message.payload.id
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

  def recipient
    bookable = params[:bookable_type].constantize.find_by(id: params[:bookable_id])
    bookable&.user
  end

  def handle_error(error)
    OpenStruct.new({ success?: false, errors: error })
  end
end
