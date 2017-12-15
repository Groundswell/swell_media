class SwellMediaEmailMigration < ActiveRecord::Migration[5.1]

	def change

		enable_extension 'hstore'

		create_table :emails, force: true do |t|
			t.string			:address
			t.integer 			:status, default: 0
			t.string			:first_name
			t.string			:last_name
			t.hstore			:properties, default: {}
			t.timestamps
		end
		add_index :emails, [:address, :status]
		add_index :emails, :status
		add_index :emails, :address, unique: true

	end
	
end
