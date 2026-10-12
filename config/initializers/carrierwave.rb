CarrierWave.configure do |config|
  if ENV["DO_SPACE_STORAGE"] == "true"
    config.storage = :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"],
      endpoint: ENV["AWS_S3_ENDPOINT"].presence
    }.compact
    config.fog_directory = ENV["AWS_S3_BUCKET"]
    config.fog_public = true
  else
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end
