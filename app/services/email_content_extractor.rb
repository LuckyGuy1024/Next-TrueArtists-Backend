class EmailContentExtractor

  def initialize(mail)
    @mail = mail
  end

  def call
    if @mail.parts.present?
      @mail.parts[0].body.decoded
    else
      @mail.decoded
    end
  end
end
