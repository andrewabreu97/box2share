if Rails.env.production?
  CarrierWave.configure do |config|
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'carrierwave'

    config.fog_provider = 'fog/aws'

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.credentials[Rails.env.to_sym][:aws][:access_key_id],
      :aws_secret_access_key  => Rails.application.credentials[Rails.env.to_sym][:aws][:secret_access_key],
      :region                 => Rails.application.credentials[Rails.env.to_sym][:aws][:region]
  #    :host                   => 's3.example.com',
  #    :endpoint               => 'https://s3.eu-west-2.amazonaws.com/'
    }
    config.fog_directory  = Rails.application.credentials[Rails.env.to_sym][:aws][:bucket]
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
