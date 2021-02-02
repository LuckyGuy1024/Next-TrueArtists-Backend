class ArtistForm
  attr_reader :avatar, :hero_banner

  def initialize(artist, options = {})
    @artist = artist
    @options = options
    @avatar = options[:avatar]
    @hero_banner = options[:hero_banner]
  end

  def valid?; end

  def update
    upload_avatar if @avatar
    upload_hero_banner if @hero_banner
    @artist.update(@options)
  end

  def upload_avatar
    @artist.avatar.attach(@avatar)
  end

  def upload_hero_banner
    @artist.hero_banner.attach(@hero_banner)
  end
end
