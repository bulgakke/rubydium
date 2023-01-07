# What it is
Rubydium is a framework for building Telegram bots.
Built on top of [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) API wrapper, it aims to provide tools for building your bots with minimum boilerplate.

It's far from being done, but all the code in the [examples](example/) directory is functional and *mostly* covered with [specs](spec/rubydium/).

# Installation
CLI tool for creating and setting up new projects is planned. For now:

1. Create your project:
`mkdir example_bot && cd example_bot`
2. Install the gem:
- Add this gem to the Gemfile:
`bundle init && echo 'gem "rubydium"' >> Gemfile`
`bundle install`
- Or install system-wide:
`gem install rubydium`
3. Create your main file:
`touch example_bot.rb`
4. See the [examples](example/) directory for bot examples.

# Configuring the bot
There's two main ways to write your config. With a block:
```ruby
ExampleBot.configure do |config|
  config.token = "1234567890:long_alphanumeric_string_goes_here"
  config.bot_username = "ends_with_bot"
  config.owner_username = "thats_you"
  config.privileged_usernames = %w[
    your_friend your_chat_moderator
  ]
end
```
Or with a hash:
```ruby
ExampleBot.config = {
  token: "1234567890:long_alphanumeric_string_goes_here",
  bot_username: "ends_with_bot",
  owner_username: "thats_you",
  privileged_usernames: %w[
    your_friend your_chat_moderator
  ]
}
```
The hash variant also means you can pass in any valid Ruby hash, regardless of where it comes from. For example, you can set the same values, if you parse
<details>
  <summary>a JSON file:</summary>

  `example_bot/config.json`:
  ```json
  {
    "token": "1234567890:long_alphanumeric_string_goes_here",
    "bot_username": "ends_with_bot",
    "owner_username": "thats_you",
    "privileged_usernames": [
      "your_friend",
      "your_chat_moderator"
    ]
  }
  ```
  `example_bot/example_bot.rb`:
  ```ruby
  require "json"
  ExampleBot.config = JSON.load_file("./config.json")
  ```
</details>

<details>
  <summary>or a YAML:</summary>

  `example_bot/config.yaml`
  ```yaml
  token: 1234567890:long_alphanumeric_string_goes_here
  bot_username: ends_with_bot
  owner_username: thats_you
  privileged_usernames:
  - your_friend
  - your_chat_moderator
  ```
  `example_bot/example_bot.rb`:
  ```ruby
  require "yaml"
  ExampleBot.config = YAML.load_file("./config.yaml")
  ```
</details>
