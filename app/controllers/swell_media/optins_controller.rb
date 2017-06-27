module SwellMedia
	class OptinsController < ApplicationController

		def create
			@optin = SwellMedia::Optin.new( optin_params )
			if @optin.save
				if @offer = LeadOffer.friendly.find_by( id: optin_params[:offer_id] )
					@offer_optin = LeadOfferOptin.create( optin: @optin, lead_offer: @offer )
					SwellMedia::LeadOfferMailer.confirm( @offer_optin ).deliver
				end

				redirect_to thank_you_optin_path( @optin.code )
			else
				set_flash "Couldn't sign up #{@optin.email}", :error, @optin
				redirect_to :back
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