class UsersController < ApplicationController
    before_action :set_user

    def reservations
        @reservations = @user.reservations
    end

    def show
        authorize current_user
        @user = current_user
    end

    private

    def set_user
        @user = current_user
    end

    def reservation_params
        params.require(:user).permit(:first_name, :last_name, :phone, :email)
    end
end
