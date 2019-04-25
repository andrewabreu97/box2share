RSpec.configure do |config|
 
  config.use_transactional_fixtures = false

  # Before the entire test suite runs, clear the test database out completely.
  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end
 
  # Sets the default database cleaning strategy to be transactions.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
 
  # Sets the default database cleaning strategy to be truncations in
  # before examples which have been flagged :js => true (Capybara and Rspec Features)
  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end
  
  # Hook up database_cleaner around the beginning and end of each test, telling
  # it to execute whatever cleanup strategy we selected beforehand.
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
 
end