# desc "Explaining what the task does"
namespace :swell_media do
	task :install do
		puts "installing"

		files = { 	'.env' => :root, 
					'.gitignore' => :root,
					'database.yml' => 'config', 
					'swell_media.rb' => 'config/initializers',
					'devise.rb' => 'config/initializers',
					'carrierwave.rb' => 'config/initializers',
					'routes.rb' => 'config',
					'application_controller.rb' => 'app/controllers',
					'user.rb' => 'app/models',
					'static_controller.rb' => 'app/controllers/swell_media',
					'application.css' => 'app/assets/stylesheets',
					'application.js' => 'app/assets/javascripts',

		}

		FileUtils::mkdir_p( File.join( Rails.root, 'app/views/swell_media/static/' ) )
		FileUtils::mkdir_p( File.join( Rails.root, 'app/views/layouts/swell_media/' ) )
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
					'swell_assets_migration.rb', 'swell_media_migration.rb', 'swell_users_migration.rb'
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
end
