module Galacto
  class IiifProxy < Rack::Proxy
    def call(env)
      request = Rack::Request.new(env)
      if request.path =~ %r{^/iiif}
        Rails.logger.debug { "IiifProxy: request for #{request.path} sent to #{@backend}" }
        super(env)
      else
        @app.call(env)
      end
    end

    def rewrite_env(env)
      env['HTTP_X_FORWARDED_HOST'] = env['SERVER_NAME']
      env['HTTP_X_FORWARDED_PORT'] = env['SERVER_PORT']
      env['HTTP_X_FORWARDED_PROTO'] = env['rack.url_scheme']
      env
    end
  end
end