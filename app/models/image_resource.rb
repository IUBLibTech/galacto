# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Image`
class ImageResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:image_resource)

  Hyrax::ValkyrieLazyMigration.migrating(self, from: ::Image) if Hyrax.config.valkyrie_transition?
end
