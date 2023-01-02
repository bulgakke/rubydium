# frozen_string_literal: true

RSpec.describe Rubydium::Mixins::CommandMacros do
  let(:message) { create_message(text: "/test_command") }
  let(:client) { instance_double(Telegram::Bot::Client) }
  let(:bot_class) { create_bot_class }
  let(:bot) do
    allow(client).to receive :api
    bot_class.new(client, message)
  end

  describe ".on_command" do
    it "registers commands with a block" do
      bot_class.define_method(:test_method) { }
      block = proc do
        test_method
      end
      bot_class.on_command "/test_command", &block

      expect(bot_class.registered_commands).to include("/test_command")

      expect(bot).to receive(:test_method)
      bot.handle_update
    end

    it "registers commands with a method name" do
      bot_class.define_method(:method_name) { }
      bot_class.on_command "/test_command", :method_name

      expect(bot_class.registered_commands).to include("/test_command")

      expect(bot).to receive(:method_name)
      bot.handle_update
    end
  end
end
