# frozen_string_literal: true

RSpec.describe Rubydium::Mixins::ControlFlow do
  let(:client) { instance_double(Telegram::Bot::Client) }

  describe '#must_be_owner' do
    let(:bot_class) do
      klass = create_bot_class(config: { owner_username: 'owner' })
      klass.define_method(:drop_database) { }
      klass.on_command '/drop_database' do
        must_be_owner do
          drop_database
        end
      end
      klass
    end

    let(:message) { create_message(text: '/drop_database', from: user) }

    let(:bot) do
      allow(client).to receive :api
      bot_class.new(client, message)
    end

    context 'when message is from owner' do
      let(:user) { create(:user, username: 'owner') }

      it 'allows owner to do things' do
        expect(bot).to receive :drop_database

        bot.handle_update
      end
    end

    context 'when message is not from owner' do
      let(:user) { create(:user, username: 'not_owner') }

      it "doesn't allow not-owners to do things" do
        expect(bot).to receive :not_from_owner

        bot.handle_update
      end
    end
  end

  describe '#must_be_reply' do
    let(:bot_class) do
      klass = create_bot_class
      klass.define_method(:mute_target_user) { }
      klass.on_command '/mute' do
        must_be_reply do
          mute_target_user
        end
      end
      klass
    end
    let(:target_message) { create_message(text: 'some text') }

    it 'executes action if the message is a reply to another message' do
      message = create_message(text: '/mute', reply_to_message: target_message)
      allow(client).to receive :api
      bot = bot_class.new(client, message)

      expect(bot).to receive :mute_target_user
      bot.handle_update
    end

    it 'halts execution if the message is not a reply' do
      message = create_message(text: '/mute')
      allow(client).to receive :api
      bot = bot_class.new(client, message)

      expect(bot).to receive :not_a_reply
      bot.handle_update
    end
  end
end
