# frozen_string_literal: true

module Rubydium
  # On every update a new instance of this class is created to handle it.
  # This is a base class that's meant to be inherited by user's actual bot class,
  # where actual logic of handling the updates is described.
  class Bot
    def self.run(token)
      Telegram::Bot::Client.run(token) do |client|
        client.listen do |update|
          new(client, update).handle_update
        end
      end
    end

    def initialize(client, update)
      @client = client
      @msg = update
      @user = @msg.from
      @chat = @msg.chat
      @replies_to = @msg.reply_to_message
      @target = @replies_to&.from
      @text = @msg.text
      @message_id = @msg.message_id
      @command = get_command(@msg.text)
    end

    def handle_update
      # Stuff happens here
    end

    private

    def get_command(text)
      return unless text

      text.split[0].delete_suffix(Config.bot_username)
    end
  end
end
