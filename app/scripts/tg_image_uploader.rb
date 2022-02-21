require 'telegram/bot'

CHAT_ID=39946793
IMAGE_PATHS=[
  # "/familysub_bot/vendor/images/a.png",
  # "/familysub_bot/vendor/images/b.png",
  # "/familysub_bot/vendor/images/c.png",
  # "/familysub_bot/vendor/images/d.png",
  # "/familysub_bot/vendor/images/e.png",
  "/familysub_bot/vendor/images/historic_people/босх.jpg",
  "/familysub_bot/vendor/images/historic_people/ганди.jpg",
  "/familysub_bot/vendor/images/historic_people/давинчи.jpg",
  "/familysub_bot/vendor/images/historic_people/дикинсон.jpg",
  "/familysub_bot/vendor/images/historic_people/ковалевская.jpg",
  "/familysub_bot/vendor/images/historic_people/марианна_снигирева.jpg",
  "/familysub_bot/vendor/images/historic_people/о_мэлли.jpg",
  "/familysub_bot/vendor/images/historic_people/феллини.jpg",
  "/familysub_bot/vendor/images/historic_people/фишер.jpg",
  "/familysub_bot/vendor/images/historic_people/шоу.jpg",
  "/familysub_bot/vendor/images/historic_people/энштейн.jpg",
]
IMAGE_EXT='image/png'

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
  bot.logger.info('Tg image uploader has been started')

  a ||= IMAGE_PATHS.map do |path_to_image|
    response = bot.api.send_photo(chat_id: CHAT_ID, photo: Faraday::UploadIO.new(path_to_image, IMAGE_EXT))

    file_id = response['result']['photo'].first['file_id']

    p "Image (#{path_to_image}) has been uploaded with id:#{file_id}"
  end

  return
end
