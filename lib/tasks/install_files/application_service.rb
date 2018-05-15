class ApplicationService


	def log_event( options={} )
		if defined?( Bunyan )
			begin
				@event_service ||= Bunyan::EventService.new
				@event_service.log_event( options )
			rescue Exception => e
				raise e unless Rails.env.production?
				NewRelic::Agent.notice_error(e) if defined?( NewRelic )
			end
		end
	end

end
