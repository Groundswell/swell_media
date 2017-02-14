
module SwellMedia
	module ApplicationControllerExtensions
		include Pundit

		def set_dest
			if params[:dest].present?
				session[:dest] = params[:dest]
			elsif (		current_user.nil? &&
						request.get? &&
						not( controller_name.match( /\outbound/ ) ) &&
						not( request.fullpath.match( /\/users/ ) ) &&
						not( request.fullpath.match( /\/login/ ) ) &&
						not( request.fullpath.match( /\/logout/ ) ) &&
						not( request.fullpath.match( /\/register/ ) ) &&
						!request.xhr? ) # don't store ajax calls
				session[:dest] = request.fullpath
			end
		end

		def set_flash( msg, code=:success, *objs )
			if flash[code].blank?
				flash[code] = "<p>#{msg}</p>"
			else
				flash[code] += "<p>#{msg}</p>"
			end
			objs.each do |obj|
				obj.errors.each do |error|
					flash[code] += "<p>#{error.to_s}: #{obj.errors[error].join(';')}</p>"
				end
			end
		end

		def set_page_meta( args={} )
			init_page_meta() unless @page_meta.present?

			@page_meta = @page_meta.deep_merge( args )
			
			if SwellMedia.twitter_handle
				@page_meta[:twitter] = @page_meta[:og].merge( { format: 'summary', site: SwellMedia.twitter_handle } )
			end

			@page_meta[:schema] = {
				"@context" => "http://schema.org/",
				"@type" => @page_meta[:type],
				"name" => @page_meta[:title]
			}

			@page_meta[:schema] = @page_meta[:schema].merge( @page_meta[:og] )

			@page_meta[:schema] = @page_meta[:schema].deep_merge( @page_meta[:structured_data] ) if @page_meta[:structured_data].present?

		end

		def init_page_meta()
			@page_meta = {
				title: SwellMedia.app_name,
				description: SwellMedia.app_description,

				og: {
					title: SwellMedia.app_name,
					type: 'Article',
					site_name: SwellMedia.app_name,
					url: request.url,
					description: SwellMedia.app_description,
					image: SwellMedia.app_logo
				}
			}

		end

	end

end