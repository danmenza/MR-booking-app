class StudiosController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
        if params[:query].present?
            if params[:query] != "Search all studios"
                studio_query = Studio.search_by_city(params[:query])
                @studios = studio_query.paginate(page: params[:page], per_page: 20)
                @selected_city = @studios[0].city
            else
                @studios = Studio.paginate(page: params[:page], per_page: 20)
                @selected_city = "Search all studios"
            end
        else
            @studios = Studio.paginate(page: params[:page], per_page: 20)
        end
        @cities = []
        studios_for_cities_query = Studio.paginate(page: params[:page], per_page: 20)
        studios_for_cities_query.each do |studio|
            if @cities.exclude?(studio.city)
                @cities << studio.city
            end
        end
        @cities << "Search all studios"
    end

    def show
        @studio = Studio.find(params[:id])
        @markers =  {
            lat: @studio.latitude,
            lng: @studio.longitude
          }
    end

    def new
        @studio = Studio.new
    end

    def create
        @studio = Studio.new(studio_params)
        if @studio.save
            redirect_to artists_sign_up_confirmation_path
        else
            render :new
        end
    end

    def get_studio_city
        self.studio.city
    end

    private

    def studio_params
        params.require(:studio).permit(:name, :address, :city, :phone, :studio_image)
    end
end
