CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    }
    if Rails.env.staging?
      config.fog_directory  = 'myflix-staging' # bucket name
    else
      config.fog_directory  = 'myflix-production' # bucket name
    end
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
