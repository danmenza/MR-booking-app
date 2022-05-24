module ApplicationHelper
  def cdn_for_artists(file)
      if "production" == ENV["RAILS_ENV"]
        "#{ENV['ARTISTS_CDN_URL']}/#{file.key}"
      else
        "#{ENV['ARTISTS_DEV_URL']}/#{file.key}"
      end
    end

  def cdn_for_studios(file)
    if "production" == ENV["RAILS_ENV"]
      "#{ENV['STUDIOS_CDN_URL']}/#{file.key}"
    else
      "#{ENV['STUDIOS_DEV_URL']}/#{file.key}"
    end
  end

  def cdn_for_users(file)
    if "production" == ENV["RAILS_ENV"]
      "#{ENV['USERS_CDN_URL']}/#{file.key}"
    else
      "#{ENV['USERS_DEV_URL']}/#{file.key}"
    end
  end

  def cdn_for_assets(file)
    if "production" == ENV["RAILS_ENV"]
      "#{ENV['ASSETS_CDN_URL']}/#{file.key}"
    else
      "#{ENV['ASSETS_DEV_URL']}/#{file.key}"
    end
  end
end
