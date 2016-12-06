
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
			init_page_meta unless @page_meta.present?
			@page_meta = @page_meta.merge(args)
		end

		def init_page_meta
			@page_meta = {
				:title => SwellMedia.app_name,
				:description => SwellMedia.app_description,
				:image => SwellMedia.app_logo,
				:site_name=> SwellMedia.app_name,
				:fb_type => 'article', # blog, website,
				:url => request.url,
				:twitter_format => 'summary',
				:twitter_site => SwellMedia.twitter_handle,
				:og => {},
				:twitter => {},
			}
		end

	end

end