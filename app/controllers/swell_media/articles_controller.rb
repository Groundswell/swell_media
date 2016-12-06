 module SwellMedia
	class ArticlesController < ApplicationController
		
		def index
			@tags = []# Article.published.tags_counts

			@query = params[:q] if params[:q].present?
			@tagged = params[:tagged]
			@author = SwellMedia.registered_user_class.constantize.friendly.find( params[:by] ) if params[:by].present?
			@category = Category.friendly.find( params[:category] || params[:cat] ) if ( params[:category] || params[:cat] ).present?

			@title = @category.try(:name)
			@title ||= "Blog"

			@articles = SwellMedia::SearchService.search( SwellMedia::Article, term: @query, category: @category, user: @author, tags: @tagged )

			# set count before pagination
			@count = @articles.count

			@articles = @articles.page( params[:page] )

			set_page_meta title: @title, og: { type: 'blog' }, twitter: { card: 'summary' }
			
		end


	end
end