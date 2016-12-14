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


			@results = SwellMedia::SearchService.search( SwellMedia::Article, term: @search_term, category: @category, users: @users, tags: @tags )
			@results = @results.page(params[:page]).per(6)


			set_page_meta( title: "#{@title} | #{SwellMedia.app_name}", description: @subtitle, avatar: @cover_img )

			render layout: ( SwellMedia.default_layouts['swell_media/categories#show'] || SwellMedia.default_layouts['swell_media/categories'] || 'application' )

		end


	end

end