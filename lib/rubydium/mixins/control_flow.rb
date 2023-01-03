# frozen_string_literal: true

module Rubydium
  module Mixins
    # These methods encapsulate common logic in control flow structures
    # a bot will probably have.
    module ControlFlow
      def must_be_owner
        return not_from_owner unless @user.username == config.owner_username

        yield
      end

      def must_be_reply
        return not_a_reply unless @replies_to

        yield
      end

      def must_be_privileged
        return not_from_privileged unless config.privileged_usernames.include?(@user.username)

        yield
      end

      private

      # Overridable methods
      def not_from_owner; end

      def not_a_reply; end

      def not_from_privileged; end
    end
  end
end
