module Galacto
  class IiifFileSetPathService
    attr_reader :file_set

    # @param [ActiveFedora::SolrHit, FileSet, Hash, SolrDocument, Hyrax::FileSetPresenter] file_set
    def initialize(file_set)
      file_set = SolrDocument.new(file_set) if file_set.class.in? [ActiveFedora::SolrHit, Hash]
      if [:id, :original_file].map { |m| file_set.respond_to?(m) }.all?   # :content_location was checked for in essi
        @file_set = file_set
      else
        raise StandardError, 'Provided file_set does not meet interface requirements'
      end
    end

    # @return [String] the id extracted from the uri, including any suffix like '/original'
    def lookup_id
      @lookup_id ||= file_set.original_file.file_identifier.to_s.match(/#{file_set.id}.*/).to_s
    end

    # @return [String, nil] a URL that resolves to an image provided by a IIIF image server
    def iiif_image_url(base_url: nil, size: nil, format: nil)
      return if lookup_id.blank?
      Hyrax.config.iiif_image_url_builder.call(lookup_id, base_url, size, format || Hyrax.config.iiif_image_size_default)
    end

    # @return [String, nil] a URL that resolves to an info.json file provided by a IIIF image server
    def iiif_info_url(base_url)
      return if lookup_id.blank?
      Hyrax.config.iiif_info_url_builder.call(lookup_id, base_url)
    end
  end
end