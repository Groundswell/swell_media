module SwellMedia

	class Page < SwellMedia::Media

		attr_accessor	:category_name


		def self.homepage
			self.find_by_slug( 'homepage' )
		end



		def category_name=( name )
			self.category = SwellMedia::PageCategory.where( name: name ).first_or_create
		end

		def page_meta
			super.merge( fb_type: 'article' )
		end

		
	end

end