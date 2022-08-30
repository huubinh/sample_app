module UsersHelper
  def gravatar_for user, size: Settings.user.default_avatar_size
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.urls.avatar_url}/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
