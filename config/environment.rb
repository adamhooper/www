# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'mislav-will_paginate', :version => '2.3.2', :source => 'http://gems.github.com/', :lib => 'will_paginate'
  config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  config.gem 'rmagick', :lib => 'RMagick' # for captcha
  config.gem 'haml', :version => '2.0.1'
  config.gem 'RedCloth', :source => 'http://code.whytheluckystiff.net', :version => '3.301', :lib => 'redcloth'
  config.gem 'ultraviolet', :lib => 'uv'
  config.gem 'mime-types', :lib => 'mime/types'
  config.gem 'archive-tar-minitar', :version => '0.5.2', :lib => 'archive/tar/minitar'

  config.time_zone = 'Eastern Time (US & Canada)'

  config.action_controller.session = {
    :session_key => '_www_session',
    :secret      => '692284ee74776ec406f957f0ee30a30137bf403472b701a3df21991d6138e51345644c9244008ffada73e21f815918c42f014931c8ddc26a5a09c171812f5383'
  }

  config.active_record.observers = 'blog/comment_observer'
end
