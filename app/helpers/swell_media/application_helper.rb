module SwellMedia
	module ApplicationHelper

		def app_local_tz( t )
			t.in_time_zone( SwellMedia.app_time_zone || 'America/Los_Angeles' )
		end

		def current_user_tz_easy_read_date_format( time )
			time = current_user.to_local_tz(time)
			if time > 1.hour.ago
				"#{time_ago_in_words( time ).gsub('about ', '')} ago"
			elsif time > current_user.to_local_tz(Time.now).beginning_of_day
				time.strftime('%l:%m%P')
			elsif time > current_user.to_local_tz(1.day.ago).beginning_of_day
				"Yesterday, #{time.strftime('%l:%m%P')}"
			elsif time > current_user.to_local_tz(7.days.ago).beginning_of_day
				time.strftime('%A, %l:%m%P')
			else
				time.to_s(:short)
			end
		end

		def set_css_if( args={} )
			puts "SwellMedia::ApplicationHelper.set_css_if"

			class_name = args[:class] || 'active'

			if args[:path].present? && args[:path].is_a?( Array )
				args[:path].each do |path|
					return class_name if current_page?( path )
				end
			elsif args[:path].present?
				return class_name if current_page?( args[:path].to_s )
			elsif args[:url].present? && args[:url].is_a?( Array )
				args[:url].each do |url|
					return class_name if current_url == url.to_s
				end
			elsif args[:url].present?
				return class_name if current_url == ( args[:url].to_s )
			elsif args[:controller].present? && args[:controller].is_a?( Array )
				args[:controller].each do |controller|
					return class_name if controller_name == controller.to_s
				end
			elsif args[:controller].present?
				return class_name if controller_name == args[:controller].to_s
			end

			return args[:else_class]

		end

	end
end
