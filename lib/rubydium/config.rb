# frozen_string_literal: true

module Rubydium
  class Bot # :nodoc:
    def self.configure
      yield config
    end

    def self.config
      @config ||= Config.new
    end

    def self.config=(config_hash)
      config_hash.each_pair do |key, value|
        config.public_send("#{key}=", value)
      end
    end

    def config
      self.class.config
    end
  end

  # Things that a full-fledged bot probably needs to know.
  # Not necessary for basic functionality, though.
  class Config
    def method_missing(method, ...)
      if method[-1] == "="
        self.class.attr_accessor method[0..-2]
        public_send(method, ...)
      else
        super(method, ...)
      end
    end
  end
end
