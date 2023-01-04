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
The hash variant also means you can pass in any valid Ruby hash, regardless of where it comes from. For example, you can set the same values, if you parse a JSON file:
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

or a YAML:
`example_bot/config.yaml`
```yaml
token: "1234567890:long_alphanumeric_string_goes_here"
bot_username: "ends_with_bot"
owner_username: "thats_you"
privileged_usernames:
 - "your_friend"
 - "your_chat_moderator"
```
`example_bot/example_bot.rb`:
```ruby
require "yaml"
ExampleBot.config = YAML.load_file("./config.yaml")
```
