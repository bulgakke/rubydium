module Rubydium
  module Mixins
    module OtherActions
      def safe_delete(maybe_message, only_bot_or_owner: true)
        message = definitely_message(maybe_message)
        from_owner = message&.from&.username == config.owner_username
        from_bot = message&.from&.id == config.bot_id
        return false unless only_bot_or_owner || from_bot || from_owner

        safe_delete_by_id(message.message_id, from_bot: true)
      end

      def safe_delete_by_id(id, from_bot: false)
        return false unless bot_can_delete_messages? || from_bot

        result = @api.delete_message(chat_id: @chat.id, message_id: id)
        result["ok"]
      rescue Telegram::Bot::Exceptions::ResponseError
        false
      end

      def definitely_message(maybe_message)
        return maybe_message if maybe_message.is_a? Telegram::Bot::Types::Message

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
