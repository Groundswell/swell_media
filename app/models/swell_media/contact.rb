module SwellMedia

	class Contact < ApplicationRecord
		self.table_name = 'contacts'

		enum status: { 'pending' => 0, 'replied' => 2, 'archive' => 3, 'trash' => 4 }

		belongs_to	:user, class_name: SwellMedia.registered_user_class, optional: true

		validates_format_of	:email, with: Devise.email_regexp, if: :email_changed?

		def self.import_from_csv( file )
			#begin
				count = 0
				CSV.foreach( file.path, headers: true ) do |row|
					contact = row['type'].constantize.new
					contact.attributes = row.to_hash.except( 'id', 'status' )
					contact.status = Contact.statuses.invert[ row['status'].to_i ]
					count = count + 1 if contact.save
				end
				return count
			#rescue
				#next
			#end
		end


		def self.to_csv
			CSV.generate do |csv|
				csv << column_names
				all.each do |contact|
					csv << contact.attributes.values_at( *column_names )
				end
			end
		end


		def to_s
			"#{self.type || 'contact'} from #{self.email}"
		end

	end
end
