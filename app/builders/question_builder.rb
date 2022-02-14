module Builders
  class QuestionBuilder
    def self.call(question:, callback_data: '')
      new(question, callback_data).call
    end

    def initialize(question, callback_data)
      @question_text = question['question']
      @answers = question.except("question")
      @callback_data = callback_data
    end

    def call
      build_text
      build_markup

      [text, markup]
    end

    private

    attr_reader :text, :markup, :answers, :question_text, :callback_data

    def build_text
      answers_as_text = answers.map { |key, value| "#{key}) #{value}" }
      @text = [question_text, *answers_as_text].join("\n")
    end

    def build_markup
      inline_keyboard_buttons = answers.keys.map { |letter| build_inline_keyboard_button(letter) }
      @markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard_buttons)
    end

    def build_inline_keyboard_button(letter)
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{letter})", callback_data: callback_data + letter)
    end
  end
end
