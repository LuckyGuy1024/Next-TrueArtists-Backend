class BaseForm
  attr_reader :avatar, :hero_banner

  def initialize(parent_object, options = {})
    @parent_object = parent_object
    @options = options
    @avatar = options[:avatar]
    @hero_banner = options[:hero_banner]
  end

  def update
    @parent_object.avatar.attach(@avatar) if @avatar
    @parent_object.hero_banner.attach(@hero_banner) if @hero_banner
    @parent_object.update(@options)
  end

  def destroy
    @parent_object.avatar.purge if @parent_object.avatar.attached?
    @parent_object.hero_banner.purge if @parent_object.hero_banner.attached?
    @parent_object.destroy
  end

  def upload_avatar
    @parent_object.avatar.attach(@avatar)
  end

  def upload_hero_banner
    @parent_object.hero_banner.attach(@hero_banner)
  end
end
