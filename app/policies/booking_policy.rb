class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def show?
    booking.user == user || booking.bookable.user == user
  end

  def update?
    booking.user == user || booking.bookable.user == user
  end

  def accept?
    booking.bookable.user == user
  end

  def reject?
    booking.bookable.user == user
  end

  def cancel?
    booking.user == user
  end

  def archive?
    booking.bookable.user == user
  end
end
