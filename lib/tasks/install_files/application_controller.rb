class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper SwellMedia::Engine.helpers

	before_action :set_page_meta


	def log_system_event( options={} )
		if defined?( Bunyan )
			bunyan_system_log( options )
		end
	end

	def log_event( options={} )
		if defined?( Bunyan )
			bunyan_log( options )
		end
	end

end
