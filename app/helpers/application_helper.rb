module ApplicationHelper
  def cdn_for_artist(file)
      "#{ENV['ARTIST_CDN_URL']}/#{file.key}"
    end

  def cdn_for_studio(file)
    "#{ENV['STUDIO_CDN_URL']}/#{file.key}"
  end

  def cdn_for_user(file)
    "#{ENV['USER_CDN_URL']}/#{file.key}"
  end
end
