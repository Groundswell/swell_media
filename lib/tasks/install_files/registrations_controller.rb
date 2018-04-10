class RegistrationsController < Devise::RegistrationsController

	layout 'sessions'


	def create
		email = params[:user][:email]
		user = User.where( email: email ).first 

		user ||= User.new( email: email, full_name: params[:user][:full_name], ip: request.ip )

		if user.encrypted_password.present?
			# this email is already registered for this site
			set_flash "#{email} is already registered. Try <a href='/forgot'>Forgot Password</a>.", :error
			redirect_back( fallback_location: '/register' )
			return false
		end

		user.password = params[:user][:password]
		user.password_confirmation = params[:user][:password_confirmation]

		if user.save
			#record_app_event( 'registration', on: @current_site, user: user, content: 'registered.' )
			set_flash "Thanks for signing up!"
        	sign_up( :user, user )
        	respond_with user, location: after_sign_in_path_for( user )
		else
			set_flash "Could not register user.", :error, user
			redirect_back( fallback_location: '/register' )
			return false
		end

	end


end
