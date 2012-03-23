require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Www
  class Application < Rails::Application
    config.active_record.observers = [ 'blog/comment_observer', 'eng/comment_observer' ]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.time_zone = 'Eastern Time (US & Canada)'

    config.generators do |g|
      g.template_engine(:haml)
      g.test_framework(:rspec, :fixture => false)
    end
  end
end
