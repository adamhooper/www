require File.expand_path('../boot', __FILE__)

# For MakeResourcefulTie
unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require 'rails/all'

Bundler.require(:default, Rails.env)

module Www
  class Application < Rails::Application
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.time_zone = 'Eastern Time (US & Canada)'

    config.generators do |g|
      g.template_engine(:haml)
    end
  end
end
