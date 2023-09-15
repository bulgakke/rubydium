# frozen_string_literal: true

require_relative "chat_thread"

module ChatGPT
  module ClassMethods
    def threads
      @threads ||= {}
    end

    def new_thread(chat_id)
      new_thread = ChatThread.new(chat_id)
      threads[chat_id] = new_thread
      new_thread
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def init_session
    self.class.new_thread(@chat.id)
    reply("Bot's context reset.")
  end

  def allowed_chat?
    return true if @user.username == config.owner_username
    return true if config.chat_gpt_allow_all_private_chats && @chat.id.positive?
    return true if config.chat_gpt_allow_all_group_chats && @chat.id.negative?
    return true if config.chat_gpt_whitelist.include?(@chat.id)

    false
  end

  def handle_gpt_command
    return if self.class.registered_commands.keys.any? { @text.match? Regexp.new(_1) }
    return unless bot_mentioned? || bot_replied_to? || private_chat?

    if !allowed_chat?
      msg = "This chat (`#{@chat.id}`) is not whitelisted for ChatGPT usage. Ask @#{config.owner_username}."
      return reply(msg, parse_mode: "Markdown")
    end

    text = @text_without_bot_mentions
    text = nil if text.gsub(/\s/, "").empty?

    target_text = @replies_to&.text || @replies_to&.caption
    target_text = nil if @target&.username == config.bot_username

    thread = self.class.threads[@chat.id] || self.class.new_thread(@chat.id)

    name = "@#{@user.username}"

    if target_text && bot_mentioned?
      target_name = "@#{@replies_to.from.username}"
      text = [add_name(target_name, target_text), add_name(name, text)].join("\n\n")
      ask_gpt(name, text, thread)
    elsif text
      text = add_name(name, text)
      ask_gpt(name, text, thread)
    end
  end

  def ask_gpt(_name, prompt, thread)
    thread.add!(:user, prompt)

    send_request(thread)
  end

  def send_request(thread)
    Async do |task|
      request = Async do
        attempt(3) do
          response = open_ai.chat(
            parameters: {
              model: "gpt-3.5-turbo",
              messages: thread.history
            }
          )

          if response["error"]
            error_text = response["error"]["message"]
            error_text += "\n\nHint: press /start to reset the context." if error_text.match? "tokens"
            raise Net::ReadTimeout, response["error"]["message"]
          else
            text = response.dig("choices", 0, "message", "content")
            puts "#{Time.now.to_i} | Chat ID: #{@chat.id}, tokens used: #{response.dig("usage", "total_tokens")}"

            reply(text)
            thread.add!(:assistant, text)
          end
        end
      end

      status = task.async do
        loop do
          send_chat_action(:typing)
          sleep 4.5
        end
      end
      request.wait

      status.stop
    end
  end

  def add_name(name, text)
    "<#{name}>:\n#{text}"
  end
end
