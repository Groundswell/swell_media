
# To admin any and all media at once. 
# Pages, blog, and any registrered media classes

module SwellMedia
	class MediaAdminController < AdminController
		before_action :get_media, except: [ :create, :empty_trash, :index ]

		def create
			authorize( Media, :admin_create? )
			@media = SwellMedia::Media.new( media_params )
			@media.publish_at ||= Time.zone.now
			@media.user = current_user
			@media.status = 'draft'

			if params[:media][:category_name].present?
				@media.category = SwellMedia::Category.where( name: params[:media][:category_name] ).first_or_create( status: 'active' )
			end

			if @media.save
				@media.update( type: params[:media][:type] ) if SwellMedia.registered_media_types.include?( params[:media][:type] )
				set_flash 'Media Created'
				redirect_to edit_media_admin_path( @media )
			else
				set_flash 'Media could not be created', :error, @media
				redirect_back( fallback_location: '/admin' )
			end
		end


		def destroy
			authorize( Media, :admin_destroy? )
			@media.trash!
			set_flash 'Media Deleted'
			redirect_back( fallback_location: '/admin' )
		end


		def edit
			authorize( @media, :admin_edit? )
		end


		def empty_trash
			authorize( Media, :admin_empty_trash? )
			@medias = Media.trash.destroy_all
			redirect_back( fallback_location: '/admin' )
			set_flash "#{@medias.count} destroyed"
		end


		def index
			authorize( Media, :admin? )
			sort_by = params[:sort_by] || 'publish_at'
			sort_dir = params[:sort_dir] || 'desc'

			@media = Media.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@media = eval "@media.#{params[:status]}"
			end

			if params[:q].present?
				@media = @media.where( "array[:q] && keywords", q: params[:q].downcase )
			end

			@media = @media.page( params[:page] )
		end


		def preview
			authorize( @media, :admin_preview? )
			@media = @media

			@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

			layout = @media.class.name.underscore.pluralize
			layout = @media.layout if @media.layout.present?
			
			render "swell_media/medias/show", layout: layout
		end


		def update
			authorize( @media, :admin_update? )
			
			@media.slug = nil if params[:media][:title] != @media.title || params[:media][:slug_pref].present?

			@media.attributes = media_params

			if params[:media][:category_name].present?
				@media.category = SwellMedia::Category.where( name: params[:media][:category_name] ).first_or_create( status: 'active' )
			end

			if @media.save
				set_flash 'Media Updated'
				redirect_to edit_media_admin_path( id: @media.id )
			else
				set_flash 'Media could not be Updated', :error, @media
				render :edit
			end
			
		end


		private
			def media_params
				params.require( :media ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :avatar, :avatar_asset_file, :avatar_asset_url )
			end

			def get_media
				@media = Media.friendly.find( params[:id] )
			end
	end

end