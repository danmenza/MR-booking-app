class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!
    
    def index
        @artists = Artist.all
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
        else
            render :new
        end
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :address, :phone, :email, :styles, artist_artwork: [])
    end

    def set_artist
        @artist = Artist.find(params[:id])
    end
end
