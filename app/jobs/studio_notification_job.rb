class StudioNotificationJob < ActiveJob::Base
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # TO-DO: find a better way to handle errors
    Rails.logger.error exception
  end

  def perform(studio_id)
    subject = {
      0 => 'First Reminder',
      1 => 'Second Reminder',
      2 => 'Third Reminder',
      3 => 'Last Reminder'
    }
    studio = Studio.find(studio_id)

    return if studio.reminder_count > 3

    case studio.status
    when 'pending'
      StudioMailer.complete_profile_reminder(studio, subject[studio.reminder_count]).deliver_now
    when 'pending_review'
      # do something
    when 'rejected'
      # do something
    when 'approved'
      # do something
    end

    # update reminder count
    studio.update(reminder_count: studio.reminder_count + 1)
  end
end
