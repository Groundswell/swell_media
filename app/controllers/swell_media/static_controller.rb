module SwellMedia
	class StaticController < ApplicationController

		def console
			raise unless Rails.env.development?
		end

		def home
			# the homepage
			render layout: 'swell_media/homepage'
		end

	end
end