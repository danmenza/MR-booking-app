class StudiosController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
        if params[:query].present?
            studio_query = Studio.search_by_city(params[:query])
            @studios = studio_query.paginate(page: params[:page], per_page: 20)
            @selected_city = @studios[0].city
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
    end

    def show
        @studio = Studio.find(params[:id])
    end

    def new
        @studio = Studio.new
    end

    def create
        @studio = Studio.new(studio_params)
        if @studio.save

        else
            render :new
        end
    end

    def get_studio_city
        self.studio.city
    end

    private

    def studio_params
        params.require(:studio).permit(:name, :address, :city, :phone)
    end
end
