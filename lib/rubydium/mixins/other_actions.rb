module Rubydium
  module Mixins
    module OtherActions
      def safe_delete(message)
        return false unless (message = definitely_message(message))
        return false unless bot_can_delete_messages? || message&.from&.id == config.bot_id

        result = @api.delete_message(chat_id: @chat.id, message_id: message.message_id)
        result["ok"]
      rescue Telegram::Bot::Exceptions::ResponseError
        false
      end

      def definitely_message(maybe_message)
        if maybe_message["message_id"]
          Telegram::Bot::Types::Message.new(maybe_message)
        elsif maybe_message["result"]["message_id"]
          Telegram::Bot::Types::Message.new(maybe_message["result"])
        else
          nil
        end
      rescue StandardError
        nil
      end
    end
  end
end
