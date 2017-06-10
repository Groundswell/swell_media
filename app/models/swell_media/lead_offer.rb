module SwellMedia
	class LeadOffer < ActiveRecord::Base
		self.table_name = 'lead_offers'

		enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }

		belongs_to 	:place

		has_many 	:lead_offer_optins

		attr_accessor :slug_pref

		include FriendlyId
		friendly_id :title, use: [ :slugged ]
	end
end