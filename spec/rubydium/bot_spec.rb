# frozen_string_literal: true

RSpec.describe Rubydium::Bot do
  let(:message) { create_message(text: '/start') }
  let(:client) { instance_double(Telegram::Bot::Client) }
  let(:bot_class) { create_bot_class }
  let(:bot) do
    allow(client).to receive :api
    bot_class.new(client, message)
  end

  describe '#help_message' do
    it 'forms list of commands with descriptions' do
      bot_class.on_command '/start', :some_method, description: 'Says hello'
      bot_class.on_command '/help', :some_method, description: 'Shows help message'

      help = bot_class.send(:help_message)
      expect(help).to eq <<~MSG.strip
        /start - Says hello
        /help - Shows help message
      MSG
    end
  end

  describe '#get_command' do
    it 'retrieves first (whitespace-separated) word that begins with a slash' do
      text = 'some words /start some words /another_command'

      command = bot.send(:get_command, text)
      expect(command).to eq '/start'
    end

    it 'returns nil if no command is found' do
      text = 'no slash here'

      command = bot.send(:get_command, text)
      expect(command).to be nil
    end

    it 'removes bot username' do
      text = '/start@yourbot some words'

      command = bot.send(:get_command, text)
      expect(command).to eq '/start'
    end

    it "doesn't remove other bots' usernames" do
      text = '/start@otherbot some words'

      command = bot.send(:get_command, text)
      expect(command).to eq '/start@otherbot'
    end
  end
end
