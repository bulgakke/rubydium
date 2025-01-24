# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Telegram::Bot::Types::User' do
    sequence :id
    first_name { 'John' }
    last_name { 'Doe' }
    username { 'johndoe' }
    language_code { 'en' }
    is_bot { false }

    initialize_with { new(**attributes) }
    skip_create
  end
end
