module SwellMedia
	class OptinsController < ApplicationController

		def create
			@optin = SwellMedia::Optin.new( optin_params )
			if @optin.save
				redirect_to thanks_optins_path
			else
				set_flash "Couldn't sign up #{@optin.email}", :error, @optin
				redirect_to :back
				return false
			end
		end



		private
			def optin_params
				params.require( :optin ).permit( :name, :email )
			end
	end
end