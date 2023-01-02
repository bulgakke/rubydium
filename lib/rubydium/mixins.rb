require_relative "mixins/command_macros"

module Rubydium
  module Mixins
    def self.included(base)
      base.include(
        CommandMacros
      )
    end
  end
end
