class UsersController < ApplicationController
    before_action :set_user

    def reservations
        @reservations = @user.reservations
    end

    private

    def set_user
        @user = current_user
    end
end
