class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!
    
    def index
        @styles = []
        @artists = Artist.all
        for artist in @artists do
            style = artist.styles.split(", ")
            @styles.append(style)
        end
    end

    def show
        @styles = []
        @artist = Artist.find(params[:id])
        for artist in @artists do
            style = artist.styles.split(", ")
            @styles.append(style)
        end
    end

    def new
        @artist = Artist.new
    end

    def create
        @artist = Artist.new(artist_params)
        if @artist.save
            redirect_to artist_path(@artist)
        else
            render :new
        end
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :email, :phone, :address, :studio, :minimum, :styles, artist_artwork: [])
    end

    def set_artist
        @artist = Artist.find(params[:id])
    end
end
