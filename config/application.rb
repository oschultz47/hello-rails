require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rottenpotatoes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Ignore specific subdirectories in the autoload or eager_load paths.
    config.autoload_lib(ignore: %w[assets tasks])
    config.assets.initialize_on_precompile = false

    # Exclude the test/system directory from autoloading or eager loading
    config.eager_load_paths -= [Rails.root.join('test/system').to_s]
    config.autoload_paths -= [Rails.root.join('test/system').to_s]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
