
# TODO 

module SwellMedia
	class AssetAdminController < AdminController

		before_filter :get_asset, except: [ :create, :empty_trash, :index ]

		def create
			authorize( Asset, :admin_create? )
			@asset = Asset.new( asset_params )
			@asset.file = params[:file] if params[:file].present?
			# @asset.publish_at ||= Time.zone.now
			@asset.user = current_user
			@asset.status = 'active'


			if @asset.save
				set_flash 'Asset Created'
				redirect_to edit_asset_admin_path( @asset )
			else
				set_flash 'Asset could not be created', :error, @asset
				redirect_to :back
			end
		end


		def destroy
			authorize( Asset, :admin_destroy? )
			@asset.destroy
			set_flash 'Asset Deleted'
			redirect_to :back
		end


		def edit
			authorize( @asset, :admin_edit? )
		end


		def empty_trash
			authorize( Asset, :admin_empty_trash? )
			@assets = Asset.trash.destroy_all
			redirect_to :back
			set_flash "#{@assets.count} destroyed"
		end


		def index
			authorize( Asset, :admin? )
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@assets = Asset.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@assets = eval "@assets.#{params[:status]}"
			end

			if params[:q].present?
				@assets = @assets.where( "array[:q] && keywords", q: params[:q].downcase )
			end

			@assets = @assets.page( params[:page] )
		end


		def preview
			authorize( @asset, :admin_preview? )
			@media = @asset

			@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

			layout = @media.class.name.underscore.pluralize
			layout = @media.layout if @media.layout.present?
			
			render "swell_media/assets/show", layout: layout
		end


		def update
			authorize( @asset, :admin_update? )

			@asset.attributes = asset_params
			@asset.file = params[:file] if params[:file].present?

			if @asset.save
				set_flash 'Asset Updated'
				redirect_to edit_asset_admin_path( id: @asset.id )
			else
				set_flash 'Asset could not be Updated', :error, @asset
				render :edit
			end
			
		end


		private
			def asset_params
				params.require( :asset ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :avatar, :avatar_asset_file, :avatar_asset_url )
			end

			def get_asset
				@asset = Asset.find( params[:id] )
			end


	end
end