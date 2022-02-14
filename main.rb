require 'telegram/bot'
require "json"

file = File.open("/familysub_bot/vendor/great_persone_test.json")
data = JSON.load(file)
questions = data["questions"]
letters_to_name = data["letters_to_name"]
name_to_description = data["name_to_description"]

def build_markup_with_answers(data, answers)
  inline_keyboard_buttons = answers.map { |key, value| Telegram::Bot::Types::InlineKeyboardButton.new(text: value, callback_data: data + key.to_s) }
  Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard_buttons)
end

def analize_result(result)
  count_by_letter = result.split('').reduce({}) do |res, i|
    res[i.to_sym] ||= 0
    res[i.to_sym] += 1
    res
  end

  max_counter = count_by_letter.values.max

  letters = count_by_letter.filter_map { |key, value| key if value == max_counter }.join('')

  p letters

  LETTER_TABLE[letters]
end

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      if (message.data.size == 7)
        heroic_name = analize_result(message.data)
        p heroic_name
        bot.api.send_message(chat_id: message.from.id, text: "Ты прям #{heroic_name}! #{DESCRIPTION[heroic_name]}")
      else
        question_data = DATA[message.data.size]
        answers = question_data.except(:question)

        markup = build_markup_with_answers(message.data, answers)
        bot.api.send_message(chat_id: message.from.id, text: question_data[:question], reply_markup: markup)
      end
    when Telegram::Bot::Types::Message
      if message.text == 'Start test'
        question_data = DATA[0]
        answers = question_data.except(:question)

        markup = build_markup_with_answers('', answers)
        bot.api.send_message(chat_id: message.chat.id, text: question_data[:question], reply_markup: markup)
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