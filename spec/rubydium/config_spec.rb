# frozen_string_literal: true

RSpec.describe Rubydium::Config do
  let(:test_bot_class) { Class.new(Rubydium::Bot) }

  before(:each) do
    test_bot_class.configure do |config|
      config.bot_username = nil
      config.privileged_usernames = nil
    end
  end

  it "sets config values using block syntax" do
    expect(test_bot_class.config.bot_username).to be nil
    expect(test_bot_class.config.privileged_usernames).to be nil

    test_bot_class.configure do |config|
      config.bot_username = "@your_bot"
      config.privileged_usernames = %w[@user_one @user_two]
    end

    expect(test_bot_class.config.bot_username).to eq("@your_bot")
    expect(test_bot_class.config.privileged_usernames).to eq(%w[@user_one @user_two])
  end

  it "sets config values using hash syntax" do
    expect(test_bot_class.config.bot_username).to be nil
    expect(test_bot_class.config.privileged_usernames).to be nil

    test_bot_class.config = {
      bot_username: "@your_bot",
      privileged_usernames: [
        "@user_one",
        "@user_two"
      ]
    }

    expect(test_bot_class.config.bot_username).to eq("@your_bot")
    expect(test_bot_class.config.privileged_usernames).to eq(%w[@user_one @user_two])
  end

  it "sets config values from an external file" do
    require "json"

    expect(test_bot_class.config.bot_username).to be nil
    expect(test_bot_class.config.privileged_usernames).to be nil

    json = <<~JSON
      {
        "bot_username": "@your_bot",
        "privileged_usernames": [
          "@user_one",
          "@user_two"
        ]
      }
    JSON

    File.write("#{TEMP_DIR}/config.json", json)
    test_bot_class.config = JSON.load_file("#{TEMP_DIR}/config.json")

    expect(test_bot_class.config.bot_username).to eq("@your_bot")
    expect(test_bot_class.config.privileged_usernames).to eq(%w[@user_one @user_two])
  end
end