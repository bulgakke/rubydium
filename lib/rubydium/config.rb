# frozen_string_literal: true

module Rubydium
  class Bot # :nodoc:
    def self.configure
      yield Config
    end
  end

  # Things that a full-fledged bot probably needs to know.
  # Not necessary for basic functionality, though.
  module Config
    attr_accessor :bot_username, :owner_username

    extend self
  end
end
