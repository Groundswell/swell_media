
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
			@page_meta = {
				title: args[:page_title] || args[:title] || SwellMedia.app_name,
				description: args[:description] || SwellMedia.app_description,

				og: {
					title: args[:title] || SwellMedia.app_name,
					type: args[:type] || 'article',
					site_name: SwellMedia.app_name,
					url: request.url,
					description: args[:description] || SwellMedia.app_description,
					image: args[:image] || SwellMedia.app_logo
				}
			}

			@page_meta = @page_meta.deep_merge( args )
			
			if SwellMedia.twitter_handle
				@page_meta[:twitter] = @page_meta[:og].merge( { format: 'summary', site: SwellMedia.twitter_handle } )
			end

			@page_meta[:schema] = { "@context" => "http://schema.org/", "@type" => "article" }.deep_merge( @page_meta[:data] ) if @page_meta[:data].present?

		end


	end

end