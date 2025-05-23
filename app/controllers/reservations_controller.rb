class ReservationsController < ApplicationController
    
    def new
        @reservation = Reservation.new
        @artist = Artist.find(params[:artist_id])
        @user = current_user
        authorize @reservation
    end

    def create
        @artist = Artist.find(params[:artist_id])
        @reservation = Reservation.new(reservation_params)
        @reservation.user = current_user
        @reservation.artist = @artist
        authorize @reservation
        if @reservation.save
            redirect_to artist_reservation_path(@artist, @reservation)
            send_user_reservation_confirmation_email(@reservation)
            send_artist_reservation_requested_email(@reservation)
            if @reservation.artist.studio_id?
                send_studio_reservation_requested_email(@reservation)
            end
        else
            render :new
        end
    end

    def show
        @reservation = Reservation.find(params[:id])
        @reservation.artist.studio.phone = view_phone_formatter(@reservation.artist.studio.phone)
        @reservation.artist.phone = view_phone_formatter(@reservation.artist.phone)
        authorize @reservation
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
        params.require(:reservation).permit(:appt_start, :appt_end, :tattoo_placement, :cover_up, :legal_age, :description, artwork: [], body_area: [])
    end

    def view_phone_formatter(phone)
        formatted_phone = "+1 (#{phone[2..4]}) #{phone[5..7]} - #{phone[8..-1]}"
        return formatted_phone
    end

    def send_user_reservation_confirmation_email(reservation)
        subject = "Tattoo Appointment - Request Confirmation"
        sender = "booking@madrabbit.com"
        recipient = reservation.user.email
        UserMailer.reservation_confirmation_email(reservation, subject, sender, recipient).deliver_now
    end

    def send_artist_reservation_requested_email(reservation)
        subject = "New Tattoo Appointment Requested"
        sender = "booking@madrabbit.com"
        # ACTION: need to update this to go to studio email address reservation.studio.email
        recipient = "dan@madrabbit.com"
        UserMailer.artist_reservation_requested_email(reservation, subject, sender, recipient).deliver_now
    end

    def send_studio_reservation_requested_email(reservation)
        subject = "New Tattoo Appointment Requested for #{reservation.artist.name}"
        sender = "booking@madrabbit.com"
        # ACTION: need to update this to go to studio email address reservation.studio.email
        recipient = "dan@madrabbit.com"
        UserMailer.studio_reservation_requested_email(reservation, subject, sender, recipient).deliver_now
    end
end