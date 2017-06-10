module SwellMedia
	class LeadOfferOptin < ActiveRecord::Base 

		self.table_name = 'lead_offer_optins'

		enum status: { 'active' => 1, 'viewed' => 2, 'redeemed' => 3, 'expired' => 4 }

		belongs_to 	:lead_offer
		belongs_to	:optin, class_name: 'SwellMedia::Optin'

		attr_accessor :name, :email

	end
end