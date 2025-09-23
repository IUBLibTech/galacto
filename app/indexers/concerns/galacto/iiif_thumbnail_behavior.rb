module Galacto
  module IiifThumbnailBehavior
    extend ActiveSupport::Concern

    included do
      self.thumbnail_path_service = Galacto::IiifThumbnailPathService
    end
  end
end
