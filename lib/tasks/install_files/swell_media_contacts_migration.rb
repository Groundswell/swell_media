class SwellMediaContactsMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :emails, :user_id, :integer, default: nil
		add_index :emails, :user_id

		add_column :contacts, :user_id, :integer, default: nil
		add_index :contacts, :user_id

	end

end
