module SwellMedia

	class Email < ApplicationRecord
		self.table_name = 'emails'

		enum status: { 'failed' => -1, 'pending' => 0, 'confirmed' => 1 }

		belongs_to	:user, class_name: SwellMedia.registered_user_class, optional: true

		validates_presence_of :address
		validates_format_of :address, with: Devise.email_regexp

		def self.create_or_update_by_email( email, args = nil )
			if args
				email_model = Email.create_with( args ).find_or_create_by( address: email.try(:downcase) )
				email_model.user = email_model.user || args.delete(:user)
				email_model.user_id = email_model.user_id || args.delete(:user_id)
				email_model.attributes = args
				email_model.save
			else
				email_model = Email.find_or_create_by( address: email.try(:downcase) )
			end

			email_model
		end

		def self.email_sanitize( value )
			return value unless value.present?

			email_parts = value.split("@")
			email_parts[0] = email_parts[0].gsub(/\./,'')
			value = email_parts.join('@')
			value = value.downcase
		end

		def update_user_if_blank( user )
			update( user: self.user || user )
		end

	end
end
