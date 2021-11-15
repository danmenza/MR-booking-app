class PagesController < ApplicationController
    skip_after_action :verify_authorized

    def navigation
        
    end
end
