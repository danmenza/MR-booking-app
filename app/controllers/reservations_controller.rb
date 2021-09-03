class ReservationsController < ApplicationController
    
    def new
        @reservation = Reservation.new
        @artist = Artist.find(params[:artist_id])
        authorize @reservation
    end

    def create
        @artist = Artist.find(params[:artist_id])
        @resservation = Reservation.new(reservation_params)
        @reservation.user = current_user
        @reservation.artist = @artist
        authorize @reservation
        if @reservation.save
            redirect_to reservation_path(@reservation)
        else
            render :new
        end
    end

    def show
        authorize @reservation
        @reservation = Reservation.find(params[:id])
    end

    def edit
        @reservation = Reservation.find(params[:id])
        @artist = Artist.find(params[:artist_id])
        authorize @reservation
    end

    def update
        @reservation = Reservation.find(params[:id])
        authorize @reservation
        @reservation.update(reservation_params)
        redirect_to reservation_path(@reservation)
    end

    def destroy
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        redirect_to users_reservations_path
    end

    private

    def reservation_params
        params.require(:reservation).permit(:appt_date, :tattoo_location, :cover_up, :style)
    end
end
