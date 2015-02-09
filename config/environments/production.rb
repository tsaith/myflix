Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = true # this is required to run on Heroku
  #config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  # Mailer
  config.action_mailer.default_url_options = { :host => 'th-myflix.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['MAILGUN_SMTP_SERVER'],
    port: ENV['MAILGUN_SMTP_PORT'],
    user_name: ENV['MAILGUN_SMTP_LOGIN'],
    password: ENV['MAILGUN_SMTP_PASSWORD'],
    domain: 'th-myflix.herokuapp.com',
    authentication: :plain,
  }

end
