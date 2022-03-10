class UsersController < ApplicationController
    before_action :set_user

    def reservations
        @reservations = @user.reservations
    end

    def show
        authorize current_user
        @user = current_user
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

    def reservation_params
        params.require(:user).permit(:first_name, :last_name, :phone, :email)
    end
end
