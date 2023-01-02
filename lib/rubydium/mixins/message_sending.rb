module Rubydium
  module Mixins
    module MessageSending
      def send_message(text)
        @api.send_message(
          chat_id: @chat.id,
          text: text
        )
      end

      def reply(text)
        @api.send_message(
          chat_id: @chat.id,
          reply_to_message_id: @message_id,
          text: text
        )
      end

      def reply_to_target(text)
        @api.send_message(
          chat_id: @chat.id,
          reply_to_message_id: @msg.reply_to_message.message_id,
          text: text
        )
      end
    end
  end
end
