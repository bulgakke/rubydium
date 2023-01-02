# frozen_string_literal: true

module Rubydium
  module Mixins
    # Macro-like definitions that describe what actions bot takes
    # in reaction to messages.
    module CommandMacros
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def on_every_message(method_name=nil, &block)
          @registered_on_every_message ||= []
          action = (method_name || block)
          raise ArgumentError, "Provide either method name or a block" unless action

          @registered_on_every_message << action
        end

        def registered_on_every_message
          @registered_on_every_message ||= []
        end

        def on_command(command, method_name=nil, description: nil, &block)
          @registered_commands ||= {}
          action = (method_name || block)
          raise ArgumentError, "Provide either method name or a block" unless action

          @registered_commands.merge!(
            {
              command => {
                action: action,
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
        self.class.registered_on_every_message.each do |action|
          execute_action(action)
        end
      end

      def execute_command
        action = self.class.registered_commands[@command][:action]

        execute_action(action)
      end

      def execute_action(action)
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
