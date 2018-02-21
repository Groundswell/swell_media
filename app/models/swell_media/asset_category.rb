module SwellMedia
	class AssetCategory < SwellMedia::Category

		def asset_count
			SwellMedia::Asset.published.where( category_id: self.id ).count
		end
	end

end