module SwellMedia

	class Email < ApplicationRecord
		self.table_name = 'emails'

		enum status: { 'failed' => -1, 'pending' => 0, 'confirmed' => 1 }

		belongs_to	:user, class_name: SwellMedia.registered_user_class, optional: true

		validates_format_of :address, with: Devise.email_regexp, if: :address_changed?

		def self.email_sanitize( value )
			return value unless value.present?

			email_parts = value.split("@")
			email_parts[0] = email_parts[0].gsub(/\./,'')
			value = email_parts.join('@')
			value = value.downcase
		end

	end
end
