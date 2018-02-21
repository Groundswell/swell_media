module SwellMedia

	class AdminController < ApplicationController
		helper_method :policy
		before_action :authenticate_user!, :authorize_admin
		layout 'admin'

		def index
			#authorize(  Media )
			@articles = Article.order( publish_at: :desc ).limit( 10 )
			@pages = Page.order( publish_at: :desc ).limit( 10 )
			@contacts = Contact.order( created_at: :desc ).limit( 10 )
		end

		protected
		def log_action_event
			# do not log admin events
		end

		private
			def authorize_admin
				authorize( Article, :admin_create? )
			end
	end

end
