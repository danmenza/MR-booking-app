module ApplicationHelper
  def cdn_for_artist(file)
      "#{ENV['CDN_URL']}/#{ENV["RAILS_ENV"]}/artists/#{file.key}"
    end

  def cdn_for_studio(file)
    "#{ENV['CDN_URL']}/#{ENV["RAILS_ENV"]}/studios/#{file.key}"
  end

  def cdn_for_user(file)
    "#{ENV['CDN_URL']}/#{ENV["RAILS_ENV"]}/users/#{file.key}"
  end
end
