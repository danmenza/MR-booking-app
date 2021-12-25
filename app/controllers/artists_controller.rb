class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
        if params[:query].present?
            artist_query = Artist.search_by_city(params[:query]).where(verified: 1)
            @artists = artist_query.paginate(page: params[:page], per_page: 20)
            @selected_city = @artists[0].city
        else
            @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        end
        @cities = []
        artists_for_cities_query = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        artists_for_cities_query.each do |artist|
            if @cities.exclude?(artist.city)
                @cities << artist.city
            end
        end
    end

    def show
        @artist = Artist.find(params[:id])
    end

    def new
        @artist = Artist.new
        @styles = ["American traditional", "Japanese traditional", "Neo traditional", "Tribal", \
                    "Fine line", "Continuous line", "Script lettering", "Watercolor", "Realism", \
                    "Black work", "Abstract", "Geometric", "New school", "Sticker", "Portrait"]
    end

    def create
        @artist = Artist.new(artist_params)
        @artist.styles.reject!(&:empty?)
        if @artist.save
            redirect_to artists_sign_up_confirmation_path
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

    private

    def artist_params
        params.require(:artist).permit(:name, :email, :phone, :address, :city, :studio, :instagram_handle, styles: [], artist_artwork: [])
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
