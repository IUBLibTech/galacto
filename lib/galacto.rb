module Galacto
  def config
    @config ||= config_yaml.with_indifferent_access
  end

  private

  def config_yaml
    load_yaml File.read(ENV.fetch('GALACTO_CONFIG_PATH', '/run/secrets/galacto_config.yml'))
  rescue Errno::ENOENT
    load_yaml File.read(Rails.root.join('config', 'galacto_config.example.yml'))
  end

  def load_yaml(str)
    YAML.safe_load(ERB.new(str).result, permitted_classes: [Symbol], aliases: true)[Rails.env]
  end

  module_function :config, :config_yaml, :load_yaml
end
