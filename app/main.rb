require 'telegram/bot'
require "json"
require_relative "builders/question_builder"
require_relative "builders/result_builder"

file = File.open("/familysub_bot/vendor/great_persone_test.json")
data = JSON.load(file)
QUESTIONS = data["questions"]

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      if (message.data.size == 7)
        text = Builders::ResultBuilder.call(callback_data: message.data)

        bot.api.send_message(chat_id: message.from.id, text: text)
      else
        text, markup = Builders::QuestionBuilder.call(question: QUESTIONS[message.data.size], callback_data: message.data)

        bot.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
      end
    when Telegram::Bot::Types::Message
      if message.text == 'Start test'
        text, markup = Builders::QuestionBuilder.call(question: QUESTIONS.first)

        bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: markup)
      else
        kb = [
          Telegram::Bot::Types::KeyboardButton.new(text: 'Start test'),
        ]
        markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: "Please, use button to start a test", reply_markup: markup)
      end
    end
  end
end