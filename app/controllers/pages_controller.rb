class PagesController < ApplicationController
    include Pundit
        skip_after_action :verify_authorized, only: [:navigation]
        skip_before_action :authenticate_user!, only: [:navigation]

    def navigation
    end
end
