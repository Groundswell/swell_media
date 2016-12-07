module SwellMedia
	class SearchService

		def self.search( type, query = {} )

			results = type.all
			results = results.published unless query[:published] == false
			results = results.where( category: ( query[:category] || query[:categories] ) ) if ( query[:category] || query[:categories] ).present?
			results = results.with_all_tags( query[:tags] ) if query[:tags].present?
			results = results.where( user: ( query[:users] || query[:user] ) ) if ( query[:users] || query[:user] ).present?

			if query[:term].present?
				search_array = query[:term].downcase.gsub(/[^\sa-z0-9]/, '').split(' ').select{ |str| str.strip.present? }
				results = results.where( "regexp_split_to_array(lower(title), E'\\\\s+') && array['#{search_array.join("','")}']" ).order("( SELECT COUNT(*) FROM ( SELECT UNNEST( regexp_split_to_array(lower(title), E'\\\\s+' ) ) INTERSECT SELECT UNNEST( array['#{search_array.join("','")}'] ) ) intersect_elements ) DESC")
			end

			results = results.order(publish_at: :desc, id: :desc)

			results

		end

	end
end