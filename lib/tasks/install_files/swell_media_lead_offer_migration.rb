class SwellMediaLeadOfferMigration < ActiveRecord::Migration[5.1]
	def change
		create_table :lead_offers do |t|
			t.references 	:place
			t.string		:title
			t.string 		:slug
			t.string 		:avatar
			t.string 		:cover_image
			t.text			:description
			t.string 		:item_name 		# name of giveaway, discount, etc...
			t.string 		:submit_label
			t.text 			:thank_you_msg
			t.string		:email_subject
			t.text			:email_msg
			t.string 		:download_url
			t.integer 		:status, default: 0
			t.timestamps
		end
		add_index :lead_offers, :slug, unique: true
		add_index :lead_offers, :status

		create_table :lead_offer_optins do |t|
			t.references 	:lead_offer
			t.references	:optin
			t.integer		:status, default: 1
			t.text 			:notes
			t.timestamps
		end
		add_index :lead_offer_optins, [ :lead_offer_id, :optin_id ]

		add_column :contacts, :code, :string
	end
end
