require 'rr'

module Bogus
  class InvocationMatcher < RR::Adapters::Rspec::InvocationMatcher
    def initialize(method, verifies_stub_definition)
      super(method)
      @verifies_stub_definition = verifies_stub_definition
      @stubbed_method_calls = []
    end

    def matches?(subject)
      @stubbed_method_calls.each do |name, args|
        @verifies_stub_definition.verify!(subject, name, args)
      end

      return super(subject.__inner_object__) if subject.respond_to?(:__inner_object__)
      return super(subject)
    end

    def method_missing(name, *args, &block)
      @stubbed_method_calls << [name, args]
      super
    end
  end
end
