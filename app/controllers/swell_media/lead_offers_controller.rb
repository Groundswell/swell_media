module SwellMedia
	class LeadOffersController < ApplicationController


		def accept
			# ok, breaking the rules here just cause I don't want to create another controller/routes
			# for offer_optins. This is really getting an optin, marking it, and sending along the
			# download.

			#start by finding the optin so we can leverage objuscated codes
			optin = Optin.find_by( code: params[:id] )

			@offer_optin = LeadOfferOptin.where( optin_id: optin.id ).last
			@offer_optin.redeemed!

			redirect_to @offer_optin.lead_offer.download_url
		end

		def show
			@offer = LeadOffer.active.friendly.find( params[:id] )
		end

	end
end
