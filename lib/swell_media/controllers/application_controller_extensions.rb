
module SwellMedia
	module ApplicationControllerExtensions
		include Pundit

		def client_ip
			request.headers['CF-Connecting-IP'] || request.remote_ip
		end

		def client_ip_country
			request.headers['CF-IPCountry']
		end

		def set_dest
			# first, clear any old dest if exists
			session[:dest] = nil
			if params[:dest].present?
				session[:dest] = params[:dest]
			end

			# greedy destination setting... an attempt to redirect back
			# to wherever user initiated login from
			# I'm not sure it ever worked right...
			# commenting out in favor of explicit dest-setting via param only
			# elsif (		current_user.nil? &&
			# 			request.get? &&
			# 			not( request.fullpath.match( /admin/ ) ) &&
			# 			not( request.fullpath.match( /\/login/ ) ) &&
			# 			not( request.fullpath.match( /\/logout/ ) ) &&
			# 			not( request.fullpath.match( /\/register/ ) ) &&
			# 			!request.xhr? ) # don't store ajax calls
			# 	session[:dest] = request.fullpath
			# end
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

		def add_page_event_data( args={} )

			@page_event_data ||= []

			@page_event_data << args

		end

		def set_page_meta( args={} )

			type = args[:type] || 'Article'

			default_page_meta_og = (SwellMedia.default_page_meta[:og] || {})

			@page_meta = SwellMedia.default_page_meta.deep_merge({
				title: args[:page_title] || args[:title] || SwellMedia.default_page_meta[:title] || SwellMedia.app_name,
				description: args[:description] || SwellMedia.default_page_meta[:description] || SwellMedia.app_description,
				url: request.url,
				og: {
					title: args[:title] || default_page_meta_og[:title] || SwellMedia.app_name,
					type: type,
					site_name: default_page_meta_og[:site_name] || SwellMedia.app_name,
					url: request.url,
					description: args[:description] || default_page_meta_og[:description] || SwellMedia.app_description,
					image: args[:image] || default_page_meta_og[:image] || SwellMedia.app_logo
				}
			})

			@page_meta = @page_meta.deep_merge( args )
			@page_meta[:schema] = { "@context" => "http://schema.org/", "@type" => type }.deep_merge( @page_meta[:data] ) if @page_meta[:data].present?

		end


	end

end
