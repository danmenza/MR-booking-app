class InstagramAuthWorker
    attr_reader :time, :client

    def perform(time: DateTime.now.utc, client: InstagramBasicDisplay::Client.new)
        @time = time
        @client = client

        # invokes artists method that filters for only artist instagram_auth_tokens that expire today and updates
        artists.find_each do |artist|
            result = refresh_request(artist)
            refresh(result, artist)
        end
    end

    private
    
    def artists
        Artist.where(auth_token_expires_at: time.beginning_of_day...time.end_of_day)
    end

    def refresh_request(artist)
        client.refresh_long_lived_token(token: artist.instagram_auth_token)
    end

    def refresh(result, artist)
        if result.success?
            artist.update!(instagram_auth_token: result.payload.access_token, auth_token_expires_at: time + result.payload.expires_in.to_i.seconds)
        else
            # log error
            puts "error refreshing instagram auth token for artist ID: #{artist.id}"
        end
    end
end