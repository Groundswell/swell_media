# encoding: utf-8

if defined?(CarrierWave)

	class AssetUploader < CarrierWave::Uploader::Base
		storage :fog
		# include CarrierWaveDirect::Uploader if defined?(CarrierWaveDirect)

		def filename
			if original_filename.present?
				extname = File.extname original_filename
				basename = File.basename(original_filename,".*")
				"#{basename}-#{secure_token}#{extname}"
			end
	     end

	     protected
	     def secure_token
	       var = :"@#{mounted_as}_secure_token"
	       model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
	     end

	end

else

	class AssetUploader

	end

end
