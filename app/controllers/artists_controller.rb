class ArtistsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
        if params[:query].present?
            artist_query = Artist.search_by_city_and_styles(params[:query])
            @artists = artist_query.paginate(page: params[:page], per_page: 20)
        else
            @artists = Artist.paginate(page: params[:page], per_page: 20)
        end
    end

    def show
        @styles = []
        @artist = Artist.find(params[:id])
        @artist.styles.split(", ").each do |style|
            @styles << style
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
end
