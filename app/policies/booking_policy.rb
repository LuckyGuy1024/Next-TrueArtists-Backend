class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def show?
    user.admin? or (booking.receiver.id or booking.sender.id) == user.id
  end

  def update?
    user.admin? or booking.sender.id == user.id
  end

  def accept_booking?
    user.admin? or booking.receiver.id == user.id
  end

  def reject_booking?
    user.admin? or booking.receiver.id == user.id
  end

  def cancel_booking?
    user.admin? or (booking.receiver.id or booking.sender.id) == user.id
  end
end
