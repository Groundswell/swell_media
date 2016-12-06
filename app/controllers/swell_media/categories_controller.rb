module SwellMedia

	class CategoriesController < ApplicationController

		def show

			@category = SwellMedia::Category.friendly.find( params[:id] ) unless params[:id] == 'all'
			@tags = params[:tags] || [params[:tag]] if params[:tag].present? || params[:tags].present?
			@users = User.friendly.find( params[:user] ) if params[:user].present?
			@search_term = params[:q]


			@title = @category.try(:name)
			@title ||= "##{@tags.join(' #')}" if @tags.present?
			@title ||= "New from #{SwellMedia.app_name}"
			@cover_img = @category.try(:cover_image)
			@subtitle = @category.try(:description)


			@results = SwellMedia::Article.published
			@results = @results.where( category: @category ) if @category.present?
			@results = @results.with_all_tags( @tags ) if @tags.present?
			@results = @results.where( user: @users ) if @users.present?

			if @search_term.present?
				search_array = @search_term.downcase.gsub(/[^\sa-z0-9]/, '').split(' ').select{ |str| str.strip.present? }
				@results = @results.where( "regexp_split_to_array(lower(title), E'\\\\s+') && array['#{search_array.join("','")}']" ).order("( SELECT COUNT(*) FROM ( SELECT UNNEST( regexp_split_to_array(lower(title), E'\\\\s+' ) ) INTERSECT SELECT UNNEST( array['#{search_array.join("','")}'] ) ) intersect_elements ) DESC")
			end

			@results = @results.order(publish_at: :desc)

			@results = @results.page(params[:page]).per(6)


			set_page_meta( title: "#{@title} | #{SwellMedia.app_name}", description: @subtitle, avatar: @cover_img )

			render layout: ( SwellMedia.default_layouts['swell_media/categories#show'] || SwellMedia.default_layouts['swell_media/categories'] || 'application' )

		end


	end

end