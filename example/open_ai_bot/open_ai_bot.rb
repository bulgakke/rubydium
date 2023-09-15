# frozen_string_literal: true

require "rubydium"
require "openai"
require "down"
require "pry"
require_relative "chat_gpt"
require_relative "dalle"
require_relative "utils"
require_relative "whisper"

# I wrote the code "until it works" as I went without much refactoring,
# so yes, it's not great, especially the ChatGPT functionality.
class ChatGPTBot < Rubydium::Bot
  include ChatGPT
  include Dalle
  include Utils
  include Whisper

  # Whenever mentioned or replied to, finds or creates a conversation thread
  # for this chat, add your message to it and returns ChatGPT's response.
  on_every_message :handle_gpt_command
  # Whenever a voice message appears in the chat, uses Whisper to transcribe
  # it and sends the result.
  # Set `ignore_forwarded` to false to automatically react to forwarded voice messages
  on_every_message :transcribe, ignore_forwarded: true

  on_command "/start", :init_session, description: "Resets ChatGPT session"
  on_command "/dalle", :dalle, description: "Sends the prompt to DALL-E"
  on_command "/transcribe", :transcribe, description: "Reply to a voice message to transcribe it"
  on_command "/pry", :pry, description: "Open a debug session in the terminal with the context of this message"

  def pry
    binding.pry
  end

  private

  def private_chat?
    @chat.type == "private"
  end

  def bot_replied_to?
    @target&.username == config.bot_username
  end

  def bot_mentioned?
    @text.split(/\s/).first == "@#{config.bot_username}"
  end

  def open_ai
    config.open_ai_client
  end
end

ChatGPTBot.configure do |config|
  config.token = "1234567890:long_alphanumeric_string_goes_here"
  config.bot_username = "ends_with_bot"
  config.owner_username = "thats_you"
  config.chat_gpt_allow_all_group_chats = true
  config.chat_gpt_allow_all_private_chats = true
  config.open_ai_token = "sk-WWEt2TQQwRwT5Q6R11erE3TerrY65E2w4q5y1t4T2TwqYYyQ"
  config.open_ai_client = OpenAI::Client.new(
    access_token: config.open_ai_token
  )
end

ChatGPTBot.run
