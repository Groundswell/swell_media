# desc "Explaining what the task does"
namespace :swell_media do
	task :install do
		puts "installing"

		files = {
					'.gitignore' => :root,
					'admin_controller.rb' => 'app/controllers',
					'database.yml' => 'config',
					'favicon.png' => 'app/assets/images',
					'app_theme.js' => 'app/assets/javascripts',
					'app_theme.css' => 'app/assets/stylesheets',
					'swell_media.rb' => 'config/initializers',
					'devise.rb' => 'config/initializers',
					'carrierwave.rb' => 'config/initializers',
					'routes.rb' => 'config',
					'application_controller.rb' => 'app/controllers',
					'user.rb' => 'app/models',
					'static_controller.rb' => 'app/controllers/swell_media',
					'passwords_controller.rb' => 'app/controllers',
					'registrations_controller.rb' => 'app/controllers',
					'sessions_controller.rb' => 'app/controllers',
					'application.css' => 'app/assets/stylesheets',
					'application.js' => 'app/assets/javascripts',
					'_gtm_body.html.erb' => 'app/views/application',
					'_gtm_head.html.erb' => 'app/views/application',

		}

		FileUtils::mkdir_p( File.join( Rails.root, 'app/views/swell_media/static/' ) )
		FileUtils::mkdir_p( File.join( Rails.root, 'app/views/layouts/swell_media/' ) )
		FileUtils::mkdir_p( File.join( Rails.root, 'app/controllers/swell_media/' ) )
		FileUtils::mkdir_p( File.join( Rails.root, 'db/migrate/' ) )

		files.each do |filename, path|
			puts "installing: #{path}/#{filename}"

			source = File.join( Gem.loaded_specs["swell_media"].full_gem_path, "lib/tasks/install_files", filename )
    		if path == :root
    			target = File.join( Rails.root, filename )
    		else
    			target = File.join( Rails.root, path, filename )
    		end
    		FileUtils.cp_r source, target
		end

		# migrations
		migrations = [
			'swell_media_migration.rb',
			'swell_media_users_migration.rb',
			'swell_media_taggable_users_migration.rb',
			'swell_media_assets_migration.rb',
			'swell_media_email_migration.rb',
			'swell_media_contacts_migration.rb',
			'swell_media_lead_offer_migration.rb',
		]

		prefix = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i

		migrations.each do |filename|
			source = File.join( Gem.loaded_specs["swell_media"].full_gem_path, "lib/tasks/install_files", filename )

    		target = File.join( Rails.root, 'db/migrate', "#{prefix}_#{filename}" )

    		FileUtils.cp_r source, target
    		prefix += 1
		end


		# copy migrations
		# create stub database.yml
		# create stub .env
		# create config/initializers/swell_media.rb
		# create config/initializers/devise.rb
		# create config/initializers/carrierwave.rb
		# mount routes
		# copy app/controllers/application_controller.rb
		# copy app/models/user.rb
		# copy app/controllers/static_controller.rb
		# copy app/views/layouts/* less admin
		# copy app/views/swell_media/static/home.html.haml

		# then user would bundle
		# rake DB
		# run Server
	end

	task :migrate_v2_6_0 do
		puts "migrating"

		files = {
			'admin_controller.rb' => 'app/controllers',
			'swell_media.rb' => 'config/initializers',
			'routes.rb' => 'config',
			'_gtm_body.html.erb' => 'app/views/application',
			'_gtm_head.html.erb' => 'app/views/application',
		}

		files.each do |filename, path|
			puts "installing: #{path}/#{filename}"

			source = File.join( Gem.loaded_specs["swell_media"].full_gem_path, "lib/tasks/install_files", filename )
    		if path == :root
    			target = File.join( Rails.root, filename )
    		else
    			target = File.join( Rails.root, path, filename )
    		end
    		FileUtils.cp_r source, target
		end

	end
end
