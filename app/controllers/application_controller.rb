class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :set_cache_headers
    include Pundit

    before_action :configure_permitted_parameters, if: :devise_controller?

    # Pundit: white-list approach.
    after_action :verify_authorized, except: :index, unless: :skip_pundit?
    after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

    # Uncomment when you *really understand* Pundit!
    # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    # def user_not_authorized
    #   flash[:alert] = "You are not authorized to perform this action."
    #   redirect_to(root_path)
    # end

    protected
    
    def configure_permitted_parameters
        # sign up & update parameters.
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :email])
    end

    def after_sign_in_path_for(resource)
        request.env['omniauth.origin'] || stored_location_for(resource) || root_path
      end

    def skip_pundit?
        devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^artists$)|(^studios$)/
    end

    def set_cache_headers
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
end
