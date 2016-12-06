module SwellMedia

	class MediaVersion < ActiveRecord::Base
		self.table_name = 'media_versions'

		enum status: { 'draft' => 0, 'published' => 1, 'archive' => 2, 'trash' => 3 }

		belongs_to	:user, class_name: SwellMedia.registered_user_class
		belongs_to 	:media

	end

end