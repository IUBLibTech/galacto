# frozen_string_literal: true

module Galacto
  class CollectionResourceIndexer < Hyrax::Indexers::PcdmCollectionIndexer
    include Hyrax::Indexer(:collection_resource)
    include Galacto::IiifThumbnailBehavior
  end
end