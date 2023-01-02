module Rubydium
  module Mixins
    module CommandMacros
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def on_every_message(method_name=nil, **options, &block)
          @registered_on_every_message ||= {}
          @registered_on_every_message.merge!({ (method_name || block) => options })
        end

        def registered_on_every_message
          @registered_on_every_message ||= {}
        end

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

      def execute_on_every_message
        self.class.registered_on_every_message.each_pair do |action, options|
          case action
          when Symbol
            public_send action
          when Proc
            instance_exec(&action)
          end
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
