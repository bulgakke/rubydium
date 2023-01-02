# frozen_string_literal: true

RSpec.describe Rubydium::Mixins::CommandMacros do
  let(:test_bot_class) do
    bot = Class.new(Rubydium::Bot)
    bot.configure do |config|
      config.bot_username = "asdf"
    end
    bot
  end

  let(:client) { double("client") }

  context "::on_command" do
    it "registers commands with a block" do
      test_bot_class.define_method(:test_method) { }
      block = proc do
        test_method
      end
      test_bot_class.on_command "/test_command", &block

      expect(test_bot_class.registered_commands).to include("/test_command")

      data = {
        message: {
          text: "/test_command"
        }
      }
      update = Telegram::Bot::Types::Update.new(data).current_message

      allow(client).to receive(:api)
      bot = test_bot_class.new(client, update)
      expect(bot).to receive(:test_method)
      bot.handle_update
    end

    it "registers commands with a method name" do
      test_bot_class.define_method(:method_name) { }
      test_bot_class.on_command "/another_command", :method_name

      expect(test_bot_class.registered_commands).to include("/another_command")

      data = {
        message: {
          text: "/another_command"
        }
      }
      update = Telegram::Bot::Types::Update.new(data).current_message

      allow(client).to receive(:api)
      bot = test_bot_class.new(client, update)
      expect(bot).to receive(:method_name)
      bot.handle_update
    end
  end
end
