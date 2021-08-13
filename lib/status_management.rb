# frozen_string_literal: true

module StatusManagement
  extend ActiveSupport::Concern

  included do
    aasm column: 'status' do
      state :pending, initial: true
      state :pending_review
      state :approved
      state :rejected

      event :pending_review, after_commit: :new_user_notification do
        transitions from: :pending, to: :pending_review
      end

      event :approve, after_commit: :send_status_notification do
        transitions from: [:pending_review, :pending, :rejected], to: :approved
      end

      event :reject, after_commit: :send_account_rejection do
        transitions from: [:pending_review, :pending, :approved], to: :rejected
      end
    end
  end

  def new_user_notification
    if instance_of?(Studio)
      StudioMailer.new_studio_notification(self).deliver_now
    else
      ArtistMailer.new_artist_notification(self).deliver_now
    end
  end

  def send_status_notification
    if instance_of?(Studio)
      StudioMailer.notify_on_account_status(email, status).deliver_now
    else
      ArtistMailer.notify_on_account_status(user.email, status).deliver_now
    end
  end

  def send_account_rejection
    if instance_of?(Studio)
      StudioMailer.notify_on_account_rejection(email).deliver_now
    else
      ArtistMailer.notify_on_account_rejection(user.email).deliver_now
    end
  end
end
