module SwellMedia
	class ContactsController < ApplicationController
		
		skip_before_filter :verify_authenticity_token, :only => [ :create ]

		def create
			@contact = ContactUs.new( contact_params )

			if @contact.save
				
				SwellMedia::ContactMailer.new_contact( @contact ).deliver if SwellMedia.contact_email_to.present?

				if ENV['MAILCHIMP_DEFAULT_LIST_ID'].present? && params[:optin].present?
					mail_api = Gibbon::API.new
					mail_api.lists.subscribe( { id: ENV['MAILCHIMP_DEFAULT_LIST_ID'], email: { email: email }, double_optin: true } )
				end
				redirect_to thanks_contacts_path
			else
				set_flash 'There was a problem...', :danger, @contact
				redirect_to :back
			end
		end


		def new
			set_page_meta title: 'Contact Us'
			render layout: ( SwellMedia.default_layouts['swell_media/contacts#new'] || SwellMedia.default_layouts['swell_media/contacts'] || 'application' )
		end


		private
			def contact_params
				params.require( :contact_us ).permit( :email, :subject, :message, :optin )
			end

	end
end