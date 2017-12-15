module SwellMedia

	class Category < ApplicationRecord
		self.table_name = 'categories'

		enum status: { 'draft' => 0, 'active' => 1, 'archive' => 2, 'trash' => 3 }
		enum availability: { 'anyone' => 1, 'logged_in_users' => 2, 'just_me' => 3 }
		
		has_many	:media

		acts_as_nested_set

		include FriendlyId
		friendly_id :name, use: :slugged

		

		def self.published( args = {} )
			self.active.anyone
		end



		def title
			self.name
		end

		def to_s
			self.name
		end

	end

end