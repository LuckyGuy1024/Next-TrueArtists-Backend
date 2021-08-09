class StudioNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(studio_id)
    studio = Studio.find(studio_id)

    case studio.status
    when 'pending'
      StudioMailer.complete_profile_reminder(studio).deliver_now
    when 'pending_review'
      # do something
    when 'rejected'
      # do something
    when 'approved'
      # do something
    end
  end
end
