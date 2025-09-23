# frozen_string_literal: true

module Galacto
  class FileSetResourceIndexer < Hyrax::Indexers::FileSetIndexer
    include Galacto::IiifThumbnailBehavior
  end
end