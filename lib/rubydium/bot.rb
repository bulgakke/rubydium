# frozen_string_literal: true

module Rubydium
  # On every update a new instance of this class is created to handle it.
  # This is a base class that's meant to be inherited by user's actual bot class,
  # where actual logic of handling the updates is described.
  class Bot
    include Mixins

    COMMAND_REGEXP = %r{\A/}

    def self.fetch_and_set_bot_id(client)
      configure do |config|
        config.bot_id = client.api.get_me.dig("result", "id") unless config.respond_to? :bot_id
      end
    end

    def self.run
      Telegram::Bot::Client.run(config.token) do |client|
        fetch_and_set_bot_id(client)

        Async do |task|
          client.listen do |update|
            task.async do
              # Not all `update`s here are messages (`listen` yields `Update#current_message`,
              # which can be `ChatMemberUpdated` etc.)
              # TODO: rework to allow for clean handling of other types.
              if update.is_a? Telegram::Bot::Types::Message
                new(client, update).handle_update
              end
            rescue StandardError => e
              puts e.detailed_message, e.backtrace
            end
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
      @topic_id = @msg.message_thread_id if @chat.is_forum
      @replies_to = @msg.reply_to_message unless @msg.reply_to_message&.message_id == @topic_id
      @target = @replies_to&.from
      @text = (@msg.text || @msg.caption).to_s
      @message_id = @msg.message_id
      @command = get_command(@msg.text || @msg.caption)
      @text_without_command = @text.gsub(@command.to_s, "").gsub(/@#{config.bot_username}\b/,
                                                                 "").strip
      @text_without_bot_mentions = @text.gsub(/@#{config.bot_username}\b/, "")
    end

    def handle_update
      execute_on_every_message
      execute_on_mention if @text.split(/\s/).first == "@#{config.bot_username}"
      # execute_on_reply if @target&.username == config.bot_username
      execute_command
    end

    private

    # For example:
    # "/start asdf", "/start@yourbot", "/start /another", "asdf /start" will all return "/start".
    def get_command(text)
      return unless text

      @command = text.split.grep(%r{\A/}).first
      @command&.delete_suffix("@#{config.bot_username}")
    end
  end
end
