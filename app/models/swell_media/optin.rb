module SwellMedia
	class Optin < SwellMedia::Contact
		before_create :generate_code



		private
			def generate_code
				self.code = loop do
					token = SecureRandom.urlsafe_base64( 6 )
					break token unless SwellMedia::Optin.exists?( code: token )
    			end
			end
	end
end