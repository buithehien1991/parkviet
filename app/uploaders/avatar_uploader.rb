class AvatarUploader < CarrierWave::Uploader::Base
  MAX_FILE_SIZE = 5.megabytes
  EXTENSION_ALLOWLIST = %w[jpg jpeg gif png webp].freeze
  CONTENT_TYPE_ALLOWLIST = [ %r{image/} ].freeze

  storage ENV["DO_SPACE_STORAGE"] == "true" ? :fog : :file

  def store_dir
    "#{folder_prefix}uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    EXTENSION_ALLOWLIST
  end

  def content_type_allowlist
    CONTENT_TYPE_ALLOWLIST
  end

  def size_range
    1..MAX_FILE_SIZE
  end

  private

  def folder_prefix
    folder = ENV.fetch("DO_SPACE_FOLDER", "").to_s.strip
    return "" if folder.blank?

    folder.delete_suffix("/") + "/"
  end
end
