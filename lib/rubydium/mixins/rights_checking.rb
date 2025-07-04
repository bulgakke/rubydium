# frozen_string_literal: true

module Rubydium
  module Mixins
    module RightsChecking
      def user_info(user_id=config.bot_id)
        @user_info ||= {}
        return @user_info[user_id] if @user_info[user_id]

        @user_info[user_id] =
          @api.get_chat_member(chat_id: @chat.id, user_id: user_id)
      end

      boolean_permissions = %i[
        can_be_edited
        can_manage_chat
        can_change_info
        can_delete_messages
        can_invite_users
        can_restrict_members
        can_pin_messages
        can_manage_topics
        can_promote_members
        can_manage_video_chats
        is_anonymous
        can_manage_voice_chat
      ]

      boolean_permissions.each do |permission|
        define_method "#{permission}?" do |user_id|
          user_info(user_id)[permission] || user_info(user_id)[:status] == 'creator'
        end

        define_method "bot_#{permission}?" do
          public_send("#{permission}?", config.bot_id)
        end
      end

      other_fields = %i[status custom_title]

      other_fields.each do |field|
        define_method field do |user_id|
          user_info(user_id)[field]
        end

        define_method "bot_#{field}" do
          public_send(field, config.bot_id)
        end
      end
    end
  end
end
