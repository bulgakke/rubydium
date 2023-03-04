# frozen_string_literal: true

module Rubydium
  # On every update a new instance of this class is created to handle it.
  # This is a base class that's meant to be inherited by user's actual bot class,
  # where actual logic of handling the updates is described.
  class Bot
    include Mixins

    COMMAND_REGEXP = %r{\A/}

    def self.run
      Telegram::Bot::Client.run(config.token) do |client|
        client.listen do |update|
          # Not all `update`s here are messages (`listen` yields `Update#current_message`,
          # which can be `ChatMemberUpdated` etc.)
          # TODO: rework to allow for clean handling of other types.
          if update.is_a? Telegram::Bot::Types::Message
            new(client, update).handle_update
          end
        end
      end
    end

    def initialize(client, update)
      @client = client
      @api = client.api
      @msg = update
      @user = @msg.from
      @chat = @msg.chat
      @replies_to = @msg.reply_to_message
      @target = @replies_to&.from
      @text = @msg.text.to_s
      @message_id = @msg.message_id
      @command = get_command(@msg.text)
      @text_without_command = @text&.gsub(@command.to_s, '').gsub(/@#{config.bot_username}\b/, '').strip
    end

    def handle_update
      execute_on_every_message
      execute_command
    end

    private

    def help_message
      self.class.registered_commands.map { |command, info|
        "#{command} - #{info[:description]}"
      }.join("\n")
    end

    # This assumes the message starts with the `/command`.
    # For example:
    # "/start asdf", "/start@yourbot", "/start /another", "asdf /start" will all return "/start".
    def get_command(text)
      return unless text

      command = text.split.grep(COMMAND_REGEXP).first
      command&.delete_suffix("@#{config.bot_username}")
    end
  end
end
