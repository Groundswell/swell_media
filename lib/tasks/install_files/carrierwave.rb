if ENV['FOG_DIRECTORY'] && defined?( CarrierWave )
	CarrierWave.configure do |config|
		config.fog_credentials = {
				:provider               => 'AWS',       # required
				:aws_access_key_id      => ENV['AMZN_ASOC_KEY'],       # required
				:aws_secret_access_key  => ENV['AMZN_ASOC_SECRET']       # required
		}
		config.fog_directory  = ENV['FOG_DIRECTORY'] # required
		config.asset_host = ENV['ASSET_HOST']

		# see https://github.com/jnicklas/carrierwave#using-amazon-s3
		# for more optional configuration

		# config.validate_unique_filename = false        # defaults to true
		# config.validate_filename_format = false        # defaults to true
		# config.validate_remote_net_url_format = false  # defaults to true
		# config.cache_dir = "#{Rails.root}/tmp/uploads"
		# config.fog_public     = true
	end
end