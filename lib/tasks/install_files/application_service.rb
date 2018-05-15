class ApplicationService


	def log_event( options={} )
		if defined?( Bunyan )
			@event_service ||= Bunyan::EventService.new
			@event_service.log_event( options )
		end
	end

end
