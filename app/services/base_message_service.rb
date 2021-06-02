# frozen_string_literal: true

class BaseMessageService

  def initialize(message)
    @message = message
  end

  def thread_id
    binding.pry
    @message.thread_id = random_thread_id unless @message.thread_id
  end

  # Send a message created on the system to a recipient
  def save_message
    return if @message.blank?

    thread_id

    @message.save
  end

  def random_thread_id
    rand(100**10).to_s.center(10, rand(10).to_s)
  end
end
