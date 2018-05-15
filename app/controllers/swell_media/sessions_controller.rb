module SwellMedia
	class SessionsController < Devise::SessionsController

		layout 'sessions'

		def create
			self.resource = warden.authenticate( auth_options )

			if self.resource

				if sign_in( resource_name, resource )
					log_event( name: 'login', on: resource, content: 'logged in.' )
					sign_in_and_redirect( resource )
				else
					set_flash 'login failed'
					redirect_back( fallback_location: root_path )
				end

			else
				redirect_to self.try(:after_sign_in_failure_path) || '/login'
			end
		end


		def destroy
			log_event( name: 'logout', on: resource, content: 'logged out.' )
			super
		end

		def new
			super
		end

	end
end