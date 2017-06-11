# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'pry'
require 'persey'

PROJECT_ROOT = File.join(Dir.pwd)

Dir[File.expand_path('..', __FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  def fixtures_path
    @path ||= File.expand_path(File.join(__FILE__, "../fixtures"))
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
