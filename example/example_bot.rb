# frozen_string_literal: true

token = "1234567890:long_alphanumeric_string_goes_here"

# Your actual logic of handling the updates goes here.
class ExampleBot < Rubydium::Bot
  on_command "/start", :greet_user # to be implemented

  def greet_user
    text = "Hi hello"
    reply(text) # to be implemented
  end
end

ExampleBot.configure do |config|
  config.bot_username = "@ends_with_bot"
  config.owner_username = "@thats_you"
end

ExampleBot.run(token)
