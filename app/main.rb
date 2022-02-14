require 'telegram/bot'
require "json"
require_relative "builders/question_builder"
require_relative "builders/result_builder"

file = File.open("/familysub_bot/vendor/great_persone_test.json")
data = JSON.load(file)
QUESTIONS = data["questions"]

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
  bot.logger.info('Bot has been started')

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      if (message.data.size == 7)
        text = Builders::ResultBuilder.call(callback_data: message.data)

        bot.api.send_message(chat_id: message.from.id, text: text)
      elsif (message.data.size == 1)
        _, markup = Builders::QuestionBuilder.call(question: QUESTIONS[message.data.size], callback_data: message.data)
        file_a_id = 'AgACAgIAAxkDAAIBWGIKje3GPcn5Vx6zKoQMQcPvrU-MAAJRvDEbQjRQSJuRm8i1--SHAQADAgADcwADIwQ'
        file_b_id = 'AgACAgIAAxkDAAIBXGIKj2LZgEM5fFeVndbsRUxW13SHAAJkvDEbQjRQSGINIpgW3SlbAQADAgADcwADIwQ'
        file_c_id = 'AgACAgIAAxkDAAIBXWIKj2My4QNWyuaBFNqtyeIc06YiAAJlvDEbQjRQSBIy4b0cHT_PAQADAgADcwADIwQ'
        file_d_id = 'AgACAgIAAxkDAAIBXmIKj2TafyLluRwvM9Ia63s8SX4gAAJmvDEbQjRQSGFoLfwU7XZcAQADAgADcwADIwQ'
        file_e_id = 'AgACAgIAAxkDAAIBX2IKj2Xh_6uKQHC_TMbFoDQHBrmvAAJnvDEbQjRQSJMu4njyh_3RAQADAgADcwADIwQ'
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: Faraday::UploadIO.new('/familysub_bot/vendor/images/A.jpg', 'image/jpg'))
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: Faraday::UploadIO.new('/familysub_bot/vendor/images/B.jpg', 'image/jpg'))['result']['photo'].first['file_id']
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: Faraday::UploadIO.new('/familysub_bot/vendor/images/C.jpg', 'image/jpg'))['result']['photo'].first['file_id']
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: Faraday::UploadIO.new('/familysub_bot/vendor/images/D.jpg', 'image/jpg'))['result']['photo'].first['file_id']
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: Faraday::UploadIO.new('/familysub_bot/vendor/images/E.jpg', 'image/jpg'))['result']['photo'].first['file_id']
        # p bot.api.send_photo(chat_id: message.from.id, caption: 'A) За любимым делом', photo: file_id)['result']['photo'].first['file_id']

        bot.api.sendMediaGroup(
          chat_id: message.from.id,
          media: [
            Telegram::Bot::Types::InputMediaPhoto.new(media: file_a_id, caption: 'A) За любимым делом'),
            Telegram::Bot::Types::InputMediaPhoto.new(media: file_b_id, caption: 'B) С семьёй'),
            Telegram::Bot::Types::InputMediaPhoto.new(media: file_c_id, caption: 'C) Супрематическим, пожалуй'),
            Telegram::Bot::Types::InputMediaPhoto.new(media: file_d_id, caption: 'D) Во всей красе'),
            Telegram::Bot::Types::InputMediaPhoto.new(media: file_e_id, caption: 'E) В образе героини любимого фильма'),
          ]
        )

        bot.api.send_message(chat_id: message.from.id, text: 'У каждой картинке есть описание с вариантом ответа', reply_markup: markup)
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