module SwellMedia

	class BrowseController < ApplicationController

		# used to browse categories, tags, etc. for any kind of media
		def index

			@category = SwellMedia::Category.friendly.find( params[:category_id] ) unless params[:category_id] == 'all' || params[:category_id].blank?
			@tags = params[:tags] || [params[:tag]] if params[:tag].present? || params[:tags].present?
			@users = User.friendly.find( params[:author] ) if params[:author].present?
			@type = params[:type] if params[:type].present?
			@search_term = params[:q]


			@title = @category.try(:name)
			@title ||= "##{@tags.join(' #')}" if @tags.present?
			@title ||= "New from #{SwellMedia.app_name}"
			@cover_img = @category.try(:cover_image)
			@subtitle = @category.try(:description)

			# todo -- implement media type scoping
			@results = SwellMedia::SearchService.search( SwellMedia::Media, term: @search_term, category: @category, users: @users, tags: @tags )
			@results = @results.page(params[:page]).per(6)

			set_page_meta( title: "#{@title} | #{SwellMedia.app_name}", description: @subtitle, avatar: @cover_img )

			render layout: 'swell_media/articles'
			# render layout: ( SwellMedia.default_layouts['swell_media/categories#show'] || SwellMedia.default_layouts['swell_media/categories'] || 'application' )

		end


	end

end