# frozen_string_literal: true

require "rubydium"

# Your actual logic of handling the updates goes here.
class ExampleBot < Rubydium::Bot
  on_every_message :log_message

  on_command "/help", description: "Show help message" do
    text = self.class.help_message
    send_message(text)
  end

  on_command "/start", :greet_user, description: "Say hello"

  def log_message
    puts "Got message from #{@user.first_name}, text: \n#{@text}"
  end

  def greet_user
    text = "Hi hello"
    reply(text)
  end
end

ExampleBot.configure do |config|
  config.token = "1234567890:long_alphanumeric_string_goes_here"
  config.bot_username = "ends_with_bot"
  config.owner_username = "thats_you"
  config.privileged_usernames = %w[
    your_friend your_chat_moderator
  ]
end

ExampleBot.run
