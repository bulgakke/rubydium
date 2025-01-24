# frozen_string_literal: true

module Dalle
  def dalle
    attempt(3) do
      prompt = @replies_to&.text || @text_without_command
      send_chat_action(:upload_photo)

      response = open_ai.images.generate(parameters: { prompt: prompt })

      send_chat_action(:upload_photo)

      url = response.dig('data', 0, 'url')

      if response['error']
        reply_code(response)
      else
        send_photo(url, reply_to_message_id: @msg.message_id)
      end
    end
  end
end
