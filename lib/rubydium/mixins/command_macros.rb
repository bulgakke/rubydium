module Rubydium
  module Mixins
    module CommandMacros
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def on_command(command, method_name=nil, &block)
          @registered_commands ||= {}

          @registered_commands.merge!({command => (method_name || block)})
        end

        def registered_commands
          @registered_commands ||= {}
        end
      end

      def execute_command
        action = self.class.registered_commands[@command]

        case action
        when Symbol
          public_send action
        when Proc
          action.call
        end
      end
    end
  end
end
