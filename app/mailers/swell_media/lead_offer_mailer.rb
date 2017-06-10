module SwellMedia
	class LeadOfferMailer < ActionMailer::Base
		def confirm( offer_optin )
			@offer_optin = offer_optin
			@offer = offer_optin.lead_offer
			mail to: @offer_optin.optin.email, from: SwellMedia.contact_email_from, subject: "#{@offer_optin.lead_offer.email_subject}"
		end
	end
end