# For development use only.
# Production deployments should use an external proxy service such as nginx.

require 'galacto/iiif_proxy'
Rails.application.config.middleware.use Galacto::IiifProxy,
                                        backend: Galacto.config[:iiif][:backend]


Rails.backtrace_cleaner.add_silencer { |line| /iiif_proxy/.match?(line) }