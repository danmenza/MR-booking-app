class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create, :show, :add_artwork, :auth, :update, :confirmation]
    
    def index
        if params[:city_query].present?
            if params[:city_query] != "All locations"
                city_query = Artist.search_by_city(params[:city_query]).where(verified: 1)
                @artists = city_query.paginate(page: params[:page], per_page: 20)
                @selected_city = @artists[0].city

                # query instagram basic display API for artist instagram feed
                @artists.each do |artist|
                    if artist.instagram_auth_token?
                        client = InstagramBasicDisplay::Client.new(auth_token: artist.instagram_auth_token)
                        response = client.media_feed
                        artist.instagram_media = response.payload.data
                    end
                end
            else
                @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
                @selected_city = "All locations"
                
                 # query instagram basic display API for artist instagram feed
                 @artists.each do |artist|
                    if artist.instagram_auth_token?
                        client = InstagramBasicDisplay::Client.new(auth_token: artist.instagram_auth_token)
                        response = client.media_feed
                        artist.instagram_media = response.payload.data
                    end
                end
            end
        else
            # if there is no city filtering, display all verified artists
            @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)

            # query instagram basic display API for artist instagram feed
            @artists.each do |artist|
                if artist.instagram_auth_token?
                    client = InstagramBasicDisplay::Client.new(auth_token: artist.instagram_auth_token)
                    response = client.media_feed
                    artist.instagram_media = response.payload.data
                end
            end
        end

        # include all cities for filtering
        @cities = []
        artists_for_cities_query = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        artists_for_cities_query.each do |artist|
            if @cities.exclude?(artist.city)
                @cities << artist.city
            end
        end
        
        # include the ability to search for all artists
        @cities << "All locations"
        @cities = @cities.sort
        
        # include all styles for filtering
        unsorted_styles = ["Anime", "Neo traditional", "Tribal", "Fine line", "Script lettering",\
            "Japanese traditional", "Continuous line", "Realism", "Surrealism", "Black work",\
            "Trash polka", "Hyper realism", "Watercolor", "Abstract", "Geometric", "Scars",\
            "Dark art", "New school", "Sticker", "Portrait", "Cover up", "American traditional"]
        @styles = unsorted_styles.sort
        
        # ACTION: this should be broken into it's own method
        @filtered_styles = []
        # here we unselect filtered styles
        if params[:filtered_styles]
            params[:filtered_styles].each do |filtered_style|
            @filtered_styles << filtered_style
            end
            if params[:filtered_style_query].present?
                # remove the filtered_style from the filtered_styles array and add back to unfiltered styles
                @filtered_styles.delete(params[:filtered_style_query])
                # remove each style in filtered styles from the unfiltered list
                @filtered_styles.each do |style|
                    @styles.delete(style)
                end

                # need to check if there are no filtered styles left in the array
                if @filtered_styles.empty?
                    @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
                else
                    styles_query = Artist.search_by_styles(@filtered_styles).where(verified: 1)
                    @artists = styles_query.paginate(page: params[:page], per_page: 20)
                end
            # here we select new styles to filter
            elsif params[:style_query].present?
                @filtered_styles << params[:style_query]
                # remove each style in filtered styles from the unfiltered list
                @filtered_styles.each do |style|
                    @styles.delete(style)
                end
                styles_query = Artist.search_by_styles(@filtered_styles).where(verified: 1)
                @artists = styles_query.paginate(page: params[:page], per_page: 20)
            end
        else
            # here we also select new styles to filter if no previously filtered_styles
            if params[:style_query].present?
                @filtered_styles << params[:style_query]
                # remove each style in filtered styles from the unfiltered list
                @filtered_styles.each do |style|
                    @styles.delete(style)
                end
                styles_query = Artist.search_by_styles(@filtered_styles).where(verified: 1)
                @artists = styles_query.paginate(page: params[:page], per_page: 20)
            end
        end
    end

    def show
        artist = Artist.find(params[:id])
        if artist.verified?
            @artist = artist
            @artist.phone = view_phone_formatter(@artist.phone)

            # query instagram basic display API for artist instagram feed
            if @artist.instagram_auth_token?
                client = InstagramBasicDisplay::Client.new(auth_token: @artist.instagram_auth_token)
                response = client.media_feed
                @artist.instagram_media = response.payload.data
            end
        end
    end

    def new
        @artist = Artist.new
        unsorted_styles = ["Anime", "Neo traditional", "Tribal", "Fine line", "Script lettering",\
            "Japanese traditional", "Continuous line", "Realism", "Surrealism", "Black work",\
            "Trash polka", "Hyper realism", "Watercolor", "Abstract", "Geometric", "Scars",\
            "Dark art", "New school", "Sticker", "Portrait", "Cover up", "American traditional"]
        @styles = unsorted_styles.sort
    end

    def add_artwork
        @artist = Artist.find(params[:id])
    end

    def update
        @artist = Artist.find(params[:id])
        begin
            if @artist.instagram_auth_token.present? || @artist.update(artist_params)
                redirect_to artists_sign_up_confirmation_path
            end
        rescue => exception
            error = exception
            flash[:alert] = "Your profile is incomplete. Please connect your instagram account or upload artist artwork to complete your profile."
            redirect_back(fallback_location: root_path)
        end
    end

    def create
        unsorted_styles = ["Anime", "Neo traditional", "Tribal", "Fine line", "Script lettering",\
            "Japanese traditional", "Continuous line", "Realism", "Surrealism", "Black work",\
            "Trash polka", "Hyper realism", "Watercolor", "Abstract", "Geometric", "Scars",\
            "Dark art", "New school", "Sticker", "Portrait", "Cover up", "American traditional"]
        @styles = unsorted_styles.sort

        @artist = Artist.new(artist_params)
        @artist.styles.reject!(&:empty?)
        @artist.phone = db_phone_formatter(@artist.phone)

        if @artist.save
            redirect_to add_artwork_path(@artist)
            # ACTION: move emails to be asynchronous
            send_new_artist_sign_up_email_artist(@artist)
            send_new_artist_sign_up_email_internal(@artist)
        else
            render :new
        end
    end

    def get_artist_city
        self.artist.city
    end

    def confirmation
    end

    def auth
        # parses Instagram redirect URI for access code and artist ID
        access_code = params[:code]
        artist_id = params[:state]
        
        return head :bad_request unless access_code

        client = InstagramBasicDisplay::Client.new

        # exchange authorization code for long-lived token (valid for 60 days)
        long_token_request = client.long_lived_token(access_code: access_code)
        if long_token_request.success?

            # save off the instagram_auth_token and convert seconds until expiration to future datetime
            token = long_token_request.payload.access_token
            
            # expiry_seconds = long_token_request.payload.expires_in
            # token_expiration_datetime = Time.now + expiry_seconds.seconds

            # ACTION: need to fix Artist.last so if artists are signing up at the same time the instagram_auth_token association doesn't get mixed up
            @artist = Artist.find(artist_id)

            # if @artist.update(instagram_auth_token: token, auth_token_expires_at: token_expiration_datetime)
            if @artist.update(instagram_auth_token: token)
                redirect_to add_artwork_path(@artist)
                flash[:success] = "You have successfully connected your instagram account!"
            else
                render json: "An error occurred while connecting your instagram account", status: 500
            end
        else
          render json: long_token_request.error, status: 400
        end
    end

    private

    def artist_params
        # ACTION: need to add back in auth_token_expires_at when functionality is ready
        params.require(:artist).permit(:name, :phone, :email, :city, :facebook, :instagram, :instagram_auth_token, :tiktok, :artist_profile, :bio, :studio_id, styles: [], artist_artwork: [])
    end

    def set_artist
        @artist = Artist.find(params[:id])
    end

    def db_phone_formatter(phone)
        if 14 == phone.length
            formatted_phone = "+1#{ phone.gsub(/[^0-9]/, "") }"
            return formatted_phone
        else
            return phone
        end
    end

    def view_phone_formatter(phone)
        if phone
            formatted_phone = "+1 (#{phone[2..4]}) #{phone[5..7]} - #{phone[8..-1]}"
            return formatted_phone
        end
    end

    def send_new_artist_sign_up_email_internal(artist)
        subject = "New Artist Sign Up"
        sender = "booking@madrabbit.com"
        recipient = "sales@madrabbit.com"
        UserMailer.new_artist_sign_up_internal_confirmation(artist, subject, sender, recipient).deliver_now
    end

    def send_new_artist_sign_up_email_artist(artist)
        subject = "Mad Rabbit Booking Platform Application Received!"
        sender = "booking@madrabbit.com"
        recipient = artist.email
        UserMailer.new_artist_sign_up_artist_confirmation(artist, subject, sender, recipient).deliver_now
    end
end
