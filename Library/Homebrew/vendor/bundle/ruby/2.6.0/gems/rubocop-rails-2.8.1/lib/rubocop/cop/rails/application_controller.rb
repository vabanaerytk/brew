# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop checks that controllers subclass ApplicationController.
      #
      # @example
      #
      #  # good
      #  class MyController < ApplicationController
      #    # ...
      #  end
      #
      #  # bad
      #  class MyController < ActionController::Base
      #    # ...
      #  end
      class ApplicationController < Cop
        MSG = 'Controllers should subclass `ApplicationController`.'
        SUPERCLASS = 'ApplicationController'
        BASE_PATTERN = '(const (const nil? :ActionController) :Base)'

        # rubocop:disable Layout/ClassStructure
        include RuboCop::Cop::EnforceSuperclass
        # rubocop:enable Layout/ClassStructure

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.source_range, self.class::SUPERCLASS)
          end
        end
      end
    end
  end
end
