class StudioForm
  attr_reader :avatar, :hero_banner

  def initialize(studio, options = {})
    @studio = studio
    @options = options
    @avatar = options[:avatar]
    @hero_banner = options[:hero_banner]
  end

  def valid?; end

  def update
    @studio.avatar.attach(@avatar) if @avatar
    @studio.hero_banner.attach(@hero_banner) if @hero_banner
    @studio.update(@options)
  end

  def upload_avatar
    @studio.avatar.attach(@avatar)
  end

  def upload_hero_banner
    @studio.hero_banner.attach(@hero_banner)
  end
end
