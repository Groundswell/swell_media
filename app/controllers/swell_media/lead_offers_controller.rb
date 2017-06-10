module SwellMedia
	class LeadOffersController < ApplicationController

		def show
			@offer = LeadOffer.active.friendly.find( params[:id] )
		end

	end
end