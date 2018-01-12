module SwellMedia
	class PageCategory < SwellMedia::Category

		def page_count
			SwellMedia::Page.published.where( category_id: self.id ).count
		end
	end

end