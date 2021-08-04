class AnnouncementJob < ActiveJob::Base
  queue_as :default

  def perform(announcement)
    if announcement.custom_emails.present?
      AnnouncementMailer.send_announcement(announcement_id, announcement.custom_emails.split(",")).deliver
    end

    if announcement.recipients.present?
      User.where(role: announcement.recipients).find_in_batches do |users|
        AnnouncementMailer.send_announcement(announcement, users.collect(&:email)).deliver
      end
    end

    ## Added for not sending email again in scheduling
    announcement.publish!
  end
end
