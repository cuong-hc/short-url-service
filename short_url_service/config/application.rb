require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShortURLService
  class Application < Rails::Application
    # config.eager_load_paths += %W( #{config.root}/lib )
    # config.autoload_paths += %W(#{config.root}/lib)
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Hanoi"
    config.active_record.time_zone_aware_types = [:datetime, :time]
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths += %W( #{config.root}/lib )
    # config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_adapter = :inline
  end
end
