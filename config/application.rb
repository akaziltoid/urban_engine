require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UrbanEngine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Redis
    redis_db = ENV.fetch('REDIS_DB', '0')
    redis_host = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
    config.redis = { db: redis_db, host: redis_host, url: File.join(redis_host, redis_db) }

    # Cache
    config.cache_store = :redis_store, File.join(config.redis[:url], 'cache')

    # Don't generate system test files.
    config.generators.system_tests = nil
    # Don't generate assets files.
    config.generators.assets = false
    # Don't generate helper files.
    config.generators.helper = false
  end
end
