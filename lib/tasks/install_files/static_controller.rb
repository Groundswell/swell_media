module SwellMedia
	class StaticController < ApplicationController

		def home
			# the homepage
			render layout: 'swell_media/homepage'
		end

	end
end