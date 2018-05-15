module SwellMedia
	class OptinsController < ApplicationController

		def create
			@optin = SwellMedia::Optin.new( optin_params )
			if @optin.save

				log_event( { name: 'email_optin', content: "opted into the email list" } )

				respond_to do |format|
					format.js {
						render :create
					}
					format.json {
						render :create
					}
					format.html {
						if params[:action] == 'back'
							set_flash @message
							redirect_back( fallback_location: thank_you_optin_path( @optin.code ) )
						else
							redirect_to thank_you_optin_path( @optin.code )
						end
					}
				end

			else
				@message = "Couldn't sign up #{@optin.email}"
				@success = false


				respond_to do |format|
					format.js {
						render :create
					}
					format.json {
						render :create
					}
					format.html {
						set_flash @message, :error, @optin
						redirect_back( fallback_location: root_path )
					}
				end
				return false
			end
		end

		def thank_you
			@optin = SwellMedia::Optin.find_by( code: params[:id] )
			@offer_optin = SwellMedia::LeadOfferOptin.where( optin_id: @optin.id ).last
		end



		private
			def optin_params
				params.require( :optin ).permit( :name, :email, :offer_id )
			end
	end
end
