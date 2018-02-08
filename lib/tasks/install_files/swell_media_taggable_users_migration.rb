class SwellMediaTaggableUsersMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :users, :tags, array: true, default: '{}'

	end
end
