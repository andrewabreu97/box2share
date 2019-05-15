class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
	before_action :set_locale

	def set_locale
		I18n.locale = params[:locale] || I18n.default_locale
	end

	def default_url_options
	  { locale: I18n.locale }
	end

  private

    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end

end
