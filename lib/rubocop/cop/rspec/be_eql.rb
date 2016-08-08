module RuboCop
  module Cop
    module RSpec
      # Check for test expectations that can use `be` instead of `eql`
      #
      # The `be` matcher compares by identity while the `eql` matcher
      # compares using `eql?`. Integers, floats, booleans, and symbols
      # can be compared by identity and therefore the `be` matcher is
      # preferable as it is a more strict test.
      #
      # @example
      #
      #   # bad
      #   expect(foo).to eql(1)
      #   expect(foo).to eql(1.0)
      #   expect(foo).to eql(true)
      #   expect(foo).to eql(false)
      #   expect(foo).to eql(:bar)
      #
      #   # good
      #   expect(foo).to be(1)
      #   expect(foo).to be(1.0)
      #   expect(foo).to be(true)
      #   expect(foo).to be(false)
      #   expect(foo).to be(:bar)
      #
      # This cop only looks for instances of `expect(...).to eql(...)`. We
      # do not check `to_not` or `not_to` since `!eql?` is more strict
      # than `!equal?`. We also do not try to flag `eq` because if
      # `a == b`, and `b` is comparable by identity, `a` is still not
      # necessarily the same type as `b` since the `#==` operator can
      # coerce objects for comparison.
      #
      class BeEql < Cop
        include RuboCop::RSpec::SpecOnly,
                RuboCop::Cop::ConfigurableEnforcedStyle

        MSG = 'Prefer `be` over `eql`'.freeze

        def_node_matcher :eql_type_with_identity, <<-PATTERN
          (send _ :to $(send nil :eql {true false int float sym}))
        PATTERN

        def on_send(node)
          eql_type_with_identity(node) do |eql|
            add_offense(eql, :selector, MSG)
          end
        end
      end
    end
  end
end
