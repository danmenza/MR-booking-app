class UsersController < ApplicationController
    before_action :set_user

    def reservations
        @reservations = @user.reservations
    end

    def show
        authorize current_user
        @user = current_user
        @user.phone = view_phone_formatter(@user.phone)
    end

    def edit
        authorize current_user
        @user = current_user
    end

    def update
        authorize current_user
        current_user.update(reservation_params)
        redirect_to user_path(current_user)
    end

    def destroy
        authorize current_user
        @user = current_user
        @user.destroy
        redirect_to root_path
    end

    private

    def set_user
        @user = current_user
    end

    def view_phone_formatter(phone)
        formatted_phone = "+1 (#{phone[2..4]}) #{phone[5..7]} - #{phone[8..-1]}"
        return formatted_phone
    end

    def reservation_params
        params.require(:user).permit(:first_name, :last_name, :phone, :email)
    end
end
