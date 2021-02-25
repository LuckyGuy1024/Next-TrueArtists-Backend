class MessageTestService
  def send_landing_updates(to_email)
    subject = "Moon Landing Mission Updates, July 20th"
    
    email_opts = {
      to: to_email,
      subject: subject,
      body: "This is a message from TrueArtists"
    }
    email =  MessageMailer.landing_email(email_opts).deliver_now
    # This can be stored in a db to use later
    message_id = email.message_id
    
    reply_opts = {
      to: to_email,
      subject: "Re: #{subject}",
      body: "This is a reply to TrueArtists",
      # Note that the `<` and `>` are manually added.
      references: "<#{message_id}>"
    }
    MessageMailer.landing_email_reply(reply_opts).deliver_now
  end
end
