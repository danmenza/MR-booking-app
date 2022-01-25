class StudiosController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index, :new, :create]
    
    def index
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
