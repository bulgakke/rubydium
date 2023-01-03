# frozen_string_literal: true

require_relative "mixins/message_sending"
require_relative "mixins/command_macros"
require_relative "mixins/control_flow"

module Rubydium
  module Mixins # :nodoc:
    def self.included(base)
      base.include(
        MessageSending,
        CommandMacros,
        ControlFlow
      )
    end
  end
end
