module SwellMedia
	class LeadOfferAdminController < AdminController
		before_filter :get_offer, except: [ :create, :index ]
		
		def create
			authorize( Optin, :admin_create? )
			@offer = LeadOffer.new( offer_params )

			if @offer.save
				set_flash 'Offer Created'
				redirect_to edit_lead_offer_admin_path( @offer.id )
			else
				set_flash 'Offer could not be created', :error, @offer
				redirect_to :back
			end
		end

		def destroy
			authorize( Optin, :admin_destroy? )
			@offer.trash!
			set_flash 'Offer Deleted'
			redirect_to :back
		end

		def edit

		end

		def index
			authorize( Optin, :admin? )
			sort_by = params[:sort_by] || 'created_at'
			sort_dir = params[:sort_dir] || 'desc'

			@offers = LeadOffer.order( "#{sort_by} #{sort_dir}" )

			@offers = @offers.page( params[:page] )
		end

		def update
			
			@offer.slug = nil if params[:lead_offer][:title] != @offer.title || params[:lead_offer][:slug_pref].present?

			@offer.attributes = offer_params

			if @offer.save
				set_flash 'Offer Updated'
				redirect_to edit_lead_offer_admin_path( id: @offer.id )
			else
				set_flash 'Offer could not be Updated', :error, @offer
				render :edit
			end
			
		end


		private
			def offer_params
				params.require( :lead_offer ).permit( :title, :slug_pref, :description, :status, :avatar, :avatar_asset_url, :cover_image  )
			end

			def get_offer
				@offer = LeadOffer.friendly.find( params[:id] )
			end


	end
end