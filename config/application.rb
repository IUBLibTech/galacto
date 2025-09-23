require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Loads Galacto.config
require File.expand_path('../../lib/galacto.rb', __FILE__)

module Galacto
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    config.add_autoload_paths_to_load_path = true

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.force_ssl = true

    config.active_job.queue_adapter     = Galacto.config[:rails][:active_job][:queue_adapter].to_sym
    config.active_job.queue_name_prefix = "galacto_#{Rails.env}"

    ##
    # Because we're using the Goddess adapter of Hyrax 5.x, we want to have a
    # canonical answer for what are the Work Types that we want to manage.
    #
    # We don't want to rely on `Hyrax.config.curation_concerns`, as these are
    # the ActiveFedora implementations.
    #
    # @return [Array<Class>]
    def self.work_types
      Hyrax.config.curation_concerns.map do |cc|
        if cc.to_s.end_with?("Resource")
          cc
        else
          # We may encounter a case where we don't have an old ActiveFedora
          # model that we're mapping to.  For example, let's say we add Game as
          # a curation concern.  And Game has only ever been written/modeled via
          # Valkyrie.  We don't want to also have a GameResource.
          "#{cc}Resource".safe_constantize || cc
        end
      end
    end
  end
end
