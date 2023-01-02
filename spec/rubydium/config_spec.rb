# frozen_string_literal: true

require "json"

RSpec.describe Rubydium::Config do
  let(:message) { create_message(text: "/start") }
  let(:client) { instance_double(Telegram::Bot::Client) }
  let(:bot_class) { create_bot_class }
  let(:bot) do
    allow(client).to receive :api
    bot_class.new(client, message)
  end
  let(:test_config) do
    {
      bot_username: "your_bot",
      privileged_usernames: [
        "user_one",
        "user_two"
      ]
    }
  end

  before(:example) do
    bot_class.configure do |config|
      config.bot_username = nil
      config.privileged_usernames = nil
    end
  end

  it "sets config values using block syntax" do
    expect(bot_class.config.bot_username).to be nil
    expect(bot_class.config.privileged_usernames).to be nil

    bot_class.configure do |config|
      config.bot_username = "your_bot"
      config.privileged_usernames = %w[user_one user_two]
    end

    expect(bot_class.config.bot_username).to eq("your_bot")
    expect(bot_class.config.privileged_usernames).to eq(%w[user_one user_two])
    expect(bot.config.bot_username).to eq("your_bot")
  end

  it "sets config values using hash syntax" do
    expect(bot_class.config.bot_username).to be nil
    expect(bot_class.config.privileged_usernames).to be nil

    bot_class.config = test_config

    expect(bot_class.config.bot_username).to eq("your_bot")
    expect(bot_class.config.privileged_usernames).to eq(%w[user_one user_two])
    expect(bot.config.bot_username).to eq("your_bot")
  end

  it "sets config values from an external file" do
    require "json"

    expect(bot_class.config.bot_username).to be nil
    expect(bot_class.config.privileged_usernames).to be nil

    json = test_config.to_json
    File.write("#{TEMP_DIR}/config.json", json)
    bot_class.config = JSON.load_file("#{TEMP_DIR}/config.json")

    expect(bot_class.config.bot_username).to eq("your_bot")
    expect(bot_class.config.privileged_usernames).to eq(%w[user_one user_two])
    expect(bot.config.bot_username).to eq("your_bot")
  end
end
