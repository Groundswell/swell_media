module SwellMedia

	class Email < ActiveRecord::Base
		self.table_name = 'emails'

		enum status: { 'failed' => -1, 'pending' => 0, 'confirmed' => 1 }

		validates_format_of :address, with: Devise.email_regexp, if: :address_changed?

	end
end
