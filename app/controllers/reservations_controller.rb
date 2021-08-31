class ReservationsController < ApplicationController

    def index
    end
    
    def new
        @reservation = Reservation.new
        @artist = Artist.find(params[:artist_id])
    end

    def create
        @artist = Artist.find(params[:artist_id])
        @resservation = Reservation.new(reservation_params)
        @reservation.user = current_user
        @reservation.artist = @artist
        if @reservation.save
            redirect_to artist_reservation_path(@artist, @reservation)
        else
            render :new
        end
    end

    def show
        @reservation = Reservation.find(params[:id])
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private

    def reservation_params
        params.require(:reservation).permit(:appt_date, :tattoo_location, :cover_up, :style)
    end
end
