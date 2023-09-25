# frozen_string_literal: true

module Rubydium
  module Mixins
    # Shorthand methods for sending messages in different ways.
    module MessageSending
      MAX_MESSAGE_SIZE = 4096

      def chunks(string, size)
        (string.length / size.to_f).ceil.times.map { |i| string[i * size, size] }
      end

      def send_message(text, split: false, **kwargs)
        return send_many_messages(text, **kwargs) if split

        @api.send_message(
          chat_id: @chat.id,
          message_thread_id: @topic_id,
          text: text,
          **kwargs
        )
      rescue Telegram::Bot::Exceptions::ResponseError => e
        data = e.send(:data)
        raise e unless data["error_code"] == 429

        retry_after = data.dig("parameters", "retry_after")
        raise e unless retry_after && retry_after > 0

        sleep retry_after
        retry
      end

      def send_many_messages(text, **kwargs)
        text_chunks = chunks(text, MAX_MESSAGE_SIZE)

        text_chunks.map do |chunk|
          send_message(text, **kwargs)
        end
      end

      def send_sticker(sticker, action: nil, **kwargs)
        chat_action_if_provided(action, :choose_sticker)

        @api.send_sticker(
          chat_id: @chat.id,
          message_thread_id: @topic_id,
          sticker: sticker,
          **kwargs
        )
      end

      def chat_action_if_provided(duration, action_name)
        if duration
          send_chat_action(action_name)
          sleep duration if duration.is_a? Numeric
        end
      end

      def send_chat_action(action, **kwargs)
        @api.send_chat_action(
          chat_id: @chat.id,
          action: action,
          message_thread_id: @topic_id,
          **kwargs
        )
      end

      def send_video(video, action: nil, **kwargs)
        chat_action_if_provided(action, :upload_video)

        @api.send_video(
          chat_id: @chat.id,
          message_thread_id: @topic_id,
          video: video,
          **kwargs
        )
      end

      def send_photo(photo, action: nil, **kwargs)
        chat_action_if_provided(action, :upload_photo)

        @api.send_photo(
          chat_id: @chat.id,
          message_thread_id: @topic_id,
          photo: photo,
          **kwargs
        )
      end

      def reply(text, **kwargs)
        send_message(
          text,
          reply_to_message_id: @message_id,
          **kwargs
        )
      end

      def reply_code(text)
        reply("```\n#{text}```", parse_mode: "Markdown")
      end

      def reply_to_target(text, **kwargs)
        send_message(
          text,
          reply_to_message_id: @replies_to.message_id,
          **kwargs
        )
      end
    end
  end
end
