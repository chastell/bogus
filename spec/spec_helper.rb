require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter]

SimpleCov.start do
  add_filter "/spec/"
end

require 'bogus'
require 'dependor/rspec'

require 'rr'

require_relative 'support/sample_fake'
require_relative 'support/fake_creator_of_fakes'
require_relative 'support/matchers'

RSpec.configure do |config|
  config.color_enabled = true
  config.mock_framework = :rr
end

# this should not be necessary...
def have_received(method = nil)
  RR::Adapters::Rspec::InvocationMatcher.new(method)
end
