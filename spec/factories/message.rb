# frozen_string_literal: true

FactoryBot.define do
  factory :message, class: "Telegram::Bot::Types::Message" do
    sequence :message_id

    chat
    date { Time.now.to_i }

    initialize_with { new(**attributes) }
  end
end
