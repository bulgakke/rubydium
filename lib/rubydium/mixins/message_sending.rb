# frozen_string_literal: true

module Rubydium
  module Mixins
    # Shorthand methods for sending messages in different ways.
    module MessageSending
      def send_message(text)
        @api.send_message(
          chat_id: @chat.id,
          text: text
        )
      end

      def reply(text, **args)
        @api.send_message(
          chat_id: @chat.id,
          reply_to_message_id: @message_id,
          text: text,
          **args
        )
      end

      def reply_code(text)
        reply("```\n#{text}```", parse_mode: "Markdown")
      end

      def reply_to_target(text)
        @api.send_message(
          chat_id: @chat.id,
          reply_to_message_id: @replies_to.message_id,
          text: text
        )
      end
    end
  end
end
