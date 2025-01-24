# frozen_string_literal: true

FactoryBot.define do
  factory :chat, class: "Telegram::Bot::Types::Chat" do
    sequence :id

    type { "supergroup" }

    initialize_with { new(**attributes) }
  end
end
