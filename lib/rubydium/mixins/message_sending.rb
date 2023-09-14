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

      def send_sticker(sticker, **kwargs)
        @api.send_sticker(
          chat_id: @chat.id,
          sticker: sticker,
          **kwargs
        )
      end

      def send_chat_action(action, **kwargs)
        @api.send_chat_action(
          chat_id: @chat.id,
          action: action,
          **kwargs
        )
      end

      def send_video(video, **kwargs)
        @api.send_video(
          chat_id: @chat.id,
          video: video,
          **kwargs
        )
      end

      def send_photo(photo, **kwargs)
        @api.send_photo(
          chat_id: @chat.id,
          photo: photo,
          **kwargs
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
