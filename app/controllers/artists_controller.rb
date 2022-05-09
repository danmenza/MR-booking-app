class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create, :show, :add_artwork, :auth, :update, :confirmation]
    
    def index
        if params[:city_query].present?
            if params[:city_query] != "Search all artists"
                city_query = Artist.search_by_city(params[:city_query]).where(verified: 1)
                @artists = city_query.paginate(page: params[:page], per_page: 20)
                @selected_city = @artists[0].city
            else
                @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
                @selected_city = "Search all artists"
            end
        else
            @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        end

        # include all cities for filtering
        @cities = []
        artists_for_cities_query = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        artists_for_cities_query.each do |artist|
            if @cities.exclude?(artist.city)
                @cities << artist.city
            end
        end
        @cities << "Search all artists"
        
        # include all styles for filtering
        @styles = ["Neo traditional", "Tribal", "Fine line", "Script lettering",\
            "Japanese traditional", "Continuous line", "Realism", "Black work",\
            "Watercolor", "Abstract", "Geometric", "Scars",\
            "New school", "Sticker", "Portrait", "Cover up", "American traditional"]
        if params[:style_query].present?
            @styles.delete(params[:style_query])
            styles_query = Artist.search_by_styles(@styles.join(" ")).where(verified: 1)
            @artists = styles_query.paginate(page: params[:page], per_page: 20)
            @filtered_styles = @styles
        else
            @filtered_styles = @styles
        end
    end

    def show
        @artist = Artist.find(params[:id])

        # query instagram basic display API for artist instagram feed
        if @artist.instagram_auth_token?
            client = InstagramBasicDisplay::Client.new(auth_token: @artist.instagram_auth_token)
            response = client.media_feed
            @media = response.payload.data
        end
    end

    def new
        @artist = Artist.new
        @styles = ["American traditional", "Japanese traditional", "Neo traditional", "Tribal", \
                    "Fine line", "Continuous line", "Script lettering", "Watercolor", "Realism", \
                    "Black work", "Abstract", "Geometric", "New school", "Sticker", "Portrait", \
                    "Cover up", "Scars"]
    end

    def add_artwork
        @artist = Artist.find(params[:id])
    end

    def update
        @artist = Artist.find(params[:id])
        if @artist.changed?
            @artist.update(artist_params)
        end
        redirect_to artists_sign_up_confirmation_path
    end

    def create
        @artist = Artist.new(artist_params)
        @artist.styles.reject!(&:empty?)
        if @artist.save
            redirect_to add_artwork_path(@artist)
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
        access_code = params[:code]
        return head :bad_request unless access_code

        client = InstagramBasicDisplay::Client.new

        # exchange authorization code for long-lived token (valid for 60 days)
        long_token_request = client.long_lived_token(access_code: access_code)
        if long_token_request.success?
            token = long_token_request.payload.access_token
            @artist = Artist.last
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
        params.require(:artist).permit(:name, :email, :phone, :address, :city, :facebook, :instagram, :instagram_auth_token, :tiktok, :artist_profile, styles: [], artist_artwork: [])
    end

    def set_artist
        @artist = Artist.find(params[:id])
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
