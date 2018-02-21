module SwellMedia

	class Email < ApplicationRecord
		self.table_name = 'emails'

		enum status: { 'failed' => -1, 'pending' => 0, 'confirmed' => 1 }

		belongs_to	:user, class_name: SwellMedia.registered_user_class, optional: true

		validates_format_of :address, with: Devise.email_regexp, if: :address_changed?

	end
end
