require_relative "mixins/message_sending"
require_relative "mixins/command_macros"

module Rubydium
  module Mixins
    def self.included(base)
      base.include(
        MessageSending,
        CommandMacros
      )
    end
  end
end
