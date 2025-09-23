# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.config.after_initialize do
  # Add all concerns that are migrating from ActiveFedora here
  WINGS_CONCERNS ||= [AdminSet, Collection, Image].freeze

  WINGS_CONCERNS.each do |klass|
    Wings::ModelRegistry.register("#{klass}Resource".constantize, klass)
    # we register itself so we can pre-translate the class in Freyja instead of having to translate in each query_service
    Wings::ModelRegistry.register(klass, klass)
  end

  Wings::ModelRegistry.register(FileSet, FileSet)
  Wings::ModelRegistry.register(Hyrax::FileSet, FileSet)
  Wings::ModelRegistry.register(Hydra::PCDM::File, Hydra::PCDM::File)
  Wings::ModelRegistry.register(Hyrax::FileMetadata, Hydra::PCDM::File)

  unless Valkyrie::MetadataAdapter.adapters.include?(:frigg)
    Valkyrie::MetadataAdapter.register(
      Frigg::MetadataAdapter.new(
        connection: ::Ldp::Client.new(Hyrax.config.fedora_connection_builder.call(
          Galacto.config[:fedora6][:url]
        )),
        base_path: Galacto.config[:fedora6][:base_path],
        schema: Valkyrie::Persistence::Fedora::PermissiveSchema.new(Hyrax::SimpleSchemaLoader.new.permissive_schema_for_valkrie_adapter),
        fedora_version: 6.5,
        fedora_pairtree_count: 4,
        fedora_pairtree_length: 2
      ),
      :frigg
    )
  end

  Valkyrie.config.metadata_adapter = :frigg
  Valkyrie.config.storage_adapter  = :fedora_storage
  Hyrax.config.query_index_from_valkyrie = true
  Hyrax.config.index_adapter = :solr_index

  # load all the sql based custom queries
  [
    Hyrax::CustomQueries::Navigators::CollectionMembers,
    Hyrax::CustomQueries::Navigators::ChildCollectionsNavigator,
    Hyrax::CustomQueries::Navigators::ParentCollectionsNavigator,
    Hyrax::CustomQueries::Navigators::ChildFileSetsNavigator,
    Hyrax::CustomQueries::Navigators::ChildWorksNavigator,
    Hyrax::CustomQueries::Navigators::FindFiles,
    Hyrax::CustomQueries::FindAccessControl,
    Hyrax::CustomQueries::FindCollectionsByType,
    Hyrax::CustomQueries::FindFileMetadata,
    Hyrax::CustomQueries::FindIdsByModel,
    Hyrax::CustomQueries::FindManyByAlternateIds,
    Hyrax::CustomQueries::FindModelsByAccess,
    Hyrax::CustomQueries::FindCountBy,
    Hyrax::CustomQueries::FindByDateRange,
    # Hyrax::CustomQueries::FindBySourceIdentifier  # bulkrax
    # Hyrax::CustomQueries::FindByModelAndPropertyValue  # iii-print
  ].each do |handler|
    Hyrax.query_service.services[0].custom_queries.register_query_handler(handler)
  end

  # [
  #   Wings::CustomQueries::FindBySourceIdentifier  # bulkrax
  # ].each do |handler|
  #   Hyrax.query_service.services[1].custom_queries.register_query_handler(handler)
  # end

  Wings::ModelRegistry.register(ImageResource, Image)
end

Rails.application.config.to_prepare do
  AdminSetResource.class_eval do
    attribute :internal_resource, Valkyrie::Types::Any.default("AdminSet"), internal: true
  end

  CollectionResource.class_eval do
    attribute :internal_resource, Valkyrie::Types::Any.default("Collection"), internal: true
  end

  Valkyrie.config.resource_class_resolver = lambda do |resource_klass_name|
    klass = resource_klass_name.gsub(/Resource$/, '').constantize
    Wings::ModelRegistry.reverse_lookup(klass) || klass
  end
end
# rubocop:enable Metrics/BlockLength
