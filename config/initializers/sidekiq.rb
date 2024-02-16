# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq-cron'

# Set up the schedule for recurring jobs
Sidekiq.configure_server do |config|
  schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  # In config/initializers/sidekiq.rb or wherever your Sidekiq configuration is set up
# Sidekiq::Cron::Job.create('Hard worker - every 5min', '*/5 * * * *', 'InterestCalculatorJob')

  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
