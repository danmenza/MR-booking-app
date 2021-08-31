class ArtistsController < ApplicationController

    def index
        @artists = Artist.all
    end

    def show
        @artist = Artist.find(params[:id])
        @artist = Artist.new
    end

    def new
        @artist = Artist.new
    end

    def create
        @artist = Artist.new(artist_params)
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :address, :phone, :email, :styles)
    end
end
