module SwellMedia
	class ArticleAdminController < AdminController
		before_filter :get_article, except: [ :create, :empty_trash, :index ]
		
		def create
			authorize( Article, :admin_create? )
			@article = Article.new( article_params )
			@article.publish_at ||= Time.zone.now
			@article.user ||= current_user
			@article.status = 'draft'

			if params[:article][:category_name].present?
				@article.category = SwellMedia::ArticleCategory.where( name: params[:article][:category_name] ).first_or_create( status: 'active' )
			end

			if @article.save
				set_flash 'Article Created'
				redirect_to edit_article_admin_path( @article )
			else
				set_flash 'Article could not be created', :error, @article
				redirect_to :back
			end
		end


		def destroy
			authorize( Article, :admin_destroy? )
			@article.trash!
			set_flash 'Article Deleted'
			redirect_to :back
		end


		def edit
			authorize( @article, :admin_edit? )

			# create new working version if none exists or if not a draft
			# unless @article.working_media_version.try(:draft?)
			#
			# 	@article.update working_media_version: @article.media_versions.create
			#
			# end
			#
			# @current_draft = @article.working_media_version
		end


		def empty_trash
			authorize( Article, :admin_empty_trash? )
			@articles = Article.trash.destroy_all
			redirect_to :back
			set_flash "#{@articles.count} destroyed"
		end


		def index
			authorize( Article, :admin? )
			sort_by = params[:sort_by] || 'publish_at'
			sort_dir = params[:sort_dir] || 'desc'

			@articles = Article.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@articles = eval "@articles.#{params[:status]}"
			end

			if params[:q].present?
				@articles = @articles.where( "array[:q] && keywords", q: params[:q].downcase )
			end

			@articles = @articles.page( params[:page] )
		end


		def preview
			authorize( @article, :admin_preview? )
			@media = @article

			@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

			layout = @media.class.name.underscore.pluralize
			layout = @media.layout if @media.layout.present?
			
			render "swell_media/articles/show", layout: layout
		end


		def update
			authorize( @article, :admin_update? )
			
			@article.slug = nil if params[:update_slug].present? && params[:article][:title] != @article.title

			@article.attributes = article_params
			@article.avatar_urls = params[:article][:avatar_urls] if params[:article].present? && params[:article][:avatar_urls].present?

			# if params[:publish].present? || @article.draft?
			#
			# 	@version = @article.media_versions.find( id: params[:current_draft_id]  )
			# 	@article.attributes = @version.versioned_attributes
			#
			# 	@version.published! if params[:publish].present?
			#
			# end

			if params[:article][:category_name].present?
				@article.category = SwellMedia::ArticleCategory.where( name: params[:article][:category_name] ).first_or_create( status: 'active' )
			end

			if @article.save
				set_flash 'Article Updated'
				redirect_to edit_article_admin_path( id: @article.id )
			else
				set_flash 'Article could not be Updated', :error, @article
				render :edit
			end
			
		end


		private
			def article_params
				params.require( :article ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :tags_csv, :avatar, :avatar_asset_file, :avatar_asset_url, :cover_image, :avatar_urls )
			end

			def get_article
				@article = Article.friendly.find( params[:id] )
			end


	end
end