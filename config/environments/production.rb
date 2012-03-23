Www::Application.configure do
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.assets.compile = false
  config.assets.compress = true
  config.assets.digest = true
  config.assets.js_compressor  = :uglifier
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.serve_static_assets = false
end
