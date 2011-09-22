module Importable
  class Uploader < CarrierWave::Uploader::Base
    storage :file

    def extension_white_list
      %w(xls xlsx)
    end

    def store_dir
      "#{Rails.root}/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.object_type}/#{model.id}"
    end
  end
end
