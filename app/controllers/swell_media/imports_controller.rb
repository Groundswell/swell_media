module SwellMedia
	class ImportsController < ApplicationController
		before_action :authenticate_user!

		def create
			authorize!( :admin, Media )
			
			if count = Importer.import( params[:file] )
				set_flash "#{count} imported"
				redirect_back( fallback_location: '/admin' )
			else
				set_flash 'Could Not Import.', :error
				redirect_back( fallback_location: '/admin' )
			end
		end


	end
end