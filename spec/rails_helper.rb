ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Request specs render layouts; ensure test JS pack exists.
if defined?(Webpacker)
  manifest = Webpacker.manifest
  entrypoint = manifest.lookup("application.js")

  unless entrypoint
    puts "Compiling test webpack packs..."
    ok = system({ "RAILS_ENV" => "test", "NODE_ENV" => "test" }, "bin/webpack")
    manifest.refresh
    entrypoint = manifest.lookup("application.js")

    unless ok && entrypoint
      raise "Webpacker test pack build failed: application.js missing in packs-test manifest"
    end
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
