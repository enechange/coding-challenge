# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'shoulda/context'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  include FactoryBot::Syntax::Methods

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework(:minitest)
      with.library(:rails)
    end
  end
end
