CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        
  config.fog_credentials = {
    provider:              'AWS',                        
    aws_access_key_id:     'AKIAIJQRYR4B4U74B2CQ',
    aws_secret_access_key: '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',
    region:                'sa-east-1'
  }
  config.fog_directory  = 'urbanas'
end