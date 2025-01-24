# frozen_string_literal: true

FactoryBot.define do
  factory :update, class: 'Telegram::Bot::Types::Update' do
    sequence :update_id

    message

    initialize_with { new(**attributes) }
    skip_create
  end
end
