if Rails.env.production?
  CarrierWave.configure do |config|
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'carrierwave'

    config.fog_provider = 'fog/aws'

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET_KEY'],
      :region                 => 'eu-west-2',
  #    :host                   => 's3.example.com',
      :endpoint               => 'https://s3.eu-west-2.amazonaws.com/'
    }
    config.fog_directory  = ENV['S3_AVATAR_BUCKET']
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
