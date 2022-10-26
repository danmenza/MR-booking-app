desc "This task is to refresh Instagram Basic Display API auth tokens that are close to expiring."

task :update_instagram_auth_tokens => :environment do
    puts "Updating instagram auth tokens..."
    InstagramAuthWorker.update_instagram_token
    puts "Completed updating instagram auth tokens."
end