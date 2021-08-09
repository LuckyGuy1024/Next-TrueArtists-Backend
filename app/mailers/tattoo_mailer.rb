class TattooMailer < ApplicationMailer
  def send_tattoo_status_notification(tattoo)
    @tattoo = tattoo
    if tattoo.studio
      email = tattoo.studio.email
      @name = tattoo.studio.name
    else
      email = tattoo.artist.user.email
      @name = tattoo.artist.name
    end

    mail(to: email, subject: 'Flagged Image')
  end
end
