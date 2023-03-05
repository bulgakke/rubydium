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
        def on_mention(method_name=nil, ignore_forwarded: true, &block)
          @registered_on_mention ||= []
          action = (method_name || block)
          raise ArgumentError, "Provide either method name or a block" unless action

          @registered_on_mention << {
            action: action,
            ignore_forwarded: ignore_forwarded
          }
        end

        def registered_on_mention
          @registered_on_mention ||= []
        end

        def on_every_message(method_name=nil, ignore_forwarded: true, &block)
          @registered_on_every_message ||= []
          action = (method_name || block)
          raise ArgumentError, "Provide either method name or a block" unless action

          @registered_on_every_message << {
            action: action,
            ignore_forwarded: ignore_forwarded
          }
        end

        def registered_on_every_message
          @registered_on_every_message ||= []
        end

        def on_command(command, method_name=nil, description: nil, ignore_forwarded: true, &block)
          @registered_commands ||= {}
          action = (method_name || block)
          raise ArgumentError, "Provide either method name or a block" unless action

          @registered_commands.merge!(
            {
              command => {
                action: action,
                description: description,
                ignore_forwarded: ignore_forwarded
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
          next if action[:ignore_forwarded] && @msg.forward_date
          execute_action(action[:action])
        end
      end

      def execute_on_mention
        self.class.registered_on_mention.each do |action|
          next if action[:ignore_forwarded] && @msg.forward_date
          execute_action(action[:action])
        end
      end

      def execute_command
        command = self.class.registered_commands[@command]
        return unless command
        return if command[:ignore_forwarded] && @msg.forward_date

        action = command[:action]

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

      # # Implement @commands
      # def execute_all_commands
      #   method_names = self.class.registered_commands.slice(*@commands).values
      #   method_name.each { |method| self.public_send(method) }
      # end
    end
  end
end
