class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
        if params[:query].present?
            artist_query = Artist.search_by_city(params[:query]).where(verified: 1)
            @artists = artist_query.paginate(page: params[:page], per_page: 20)
        else
            @artists = Artist.paginate(page: params[:page], per_page: 20).where(verified: 1)
        end
        @cities = []
        @artists.each do |artist|
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
    end

    def create
        @artist = Artist.new(artist_params)
        if @artist.save
            redirect_to artist_path(@artist)
            send_new_artist_sign_up_email(@artist)
        else
            render :new
        end
    end

    def get_artist_city
        self.artist.city
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :email, :phone, :address, :city, :studio, :minimum, :styles, artist_artwork: [])
    end

    def set_artist
        @artist = Artist.find(params[:id])
    end

    def send_new_artist_sign_up_email(artist)
        subject = "New Artist Sign Up"
        sender = "booking@madrabbit.com"
        recipient = "dan@madrabbit.com"
        UserMailer.new_artist_sign_up(artist, subject, sender, recipient).deliver_now
    end
end
