if ENV['COVERAGE']
  # Run Coverage report
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_group 'Finders', 'app/finders'
    add_group 'Mailers', 'app/mailers'
    add_group 'Paginators', 'app/paginators'
    add_group 'Services', 'app/services'
    add_group 'Sorters', 'app/sorters'
    add_group 'Validators', 'app/validators'
    add_group 'Libraries', 'lib/spree'

    add_filter '/bin/'
    add_filter '/db/'
    add_filter '/script/'
    add_filter '/spec/'
    add_filter '/lib/spree/testing_support/'
    add_filter '/lib/generators/'

    coverage_dir "#{ENV['COVERAGE_DIR']}/core" if ENV['COVERAGE_DIR']
  end
end

# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV['RAILS_ENV'] ||= 'test'

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
end

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require 'spree/testing_support/i18n' if ENV['CHECK_TRANSLATIONS']

require 'spree/testing_support/factories'
require 'spree/testing_support/preferences'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/kernel'
require 'spree/testing_support/rspec_retry_config'

RSpec.configure do |config|
  config.color = true
  config.default_formatter = 'doc'
  config.fail_fast = ENV['FAIL_FAST'] || false
  config.fixture_path = File.join(__dir__, 'fixtures')
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before do
    begin
      Rails.cache.clear
      reset_spree_preferences
    rescue Errno::ENOTEMPTY
    end
  end

  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::Kernel

  config.before(:suite) do
    # Clean out the database state before the tests run
    DatabaseCleaner.clean_with(:truncation)
    # Force jobs to be executed in a synchronous way
    ActiveJob::Base.queue_adapter = :inline
  end

  config.before(:each, :inline_jobs) do
    ActiveJob::Base.queue_adapter = :test
  end

  config.after(:each, :inline_jobs) do
    ActiveJob::Base.queue_adapter = :inline
  end

  config.order = :random
  Kernel.srand config.seed
end
