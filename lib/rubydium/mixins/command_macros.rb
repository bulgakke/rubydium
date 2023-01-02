module Rubydium
  module Mixins
    module CommandMacros
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def on_command(command, method_name=nil, description: nil, &block)
          @registered_commands ||= {}

          @registered_commands.merge!(
            {
              command => {
                action: (method_name || block),
                description: description
              }
            }
          )
        end

        def registered_commands
          @registered_commands ||= {}
        end
      end

      def execute_command
        action = self.class.registered_commands[@command][:action]

        case action
        when Symbol
          public_send action
        when Proc
          instance_exec(&action)
        end
      end
    end
  end
end
