module Builders
  class ResultBuilder
    def self.call(callback_data:)
      new(callback_data).call
    end

    def initialize(callback_data)
      file = File.open("/familysub_bot/vendor/great_persone_test.json")
      data = JSON.load(file)
    
      @results = data["results"]
      @descriptions = data["descriptions"]
      @callback_data = callback_data
    end

    def call
      build_slug
      build_name
      build_description
      image_id = find_image_id
  
      ["Ты прям #{name}! #{description}", image_id]
    end

    private

    attr_reader :name, :description, :results, :descriptions, :slug, :callback_data

    def build_slug
      count_by_letter = callback_data
        .split('')
        .reduce({}) { |res, i|
          res[i.to_sym] ||= 0
          res[i.to_sym] += 1
          res
        }
    
      max_counter = count_by_letter.values.max
    
      @slug = count_by_letter
        .filter_map { |key, value| key if value == max_counter }
        .sort
        .join('')
    end

    def build_name
      @name = results[slug]
    end

    def build_description
      @description = descriptions[name]
    end

    def find_image_id
      image_ids_file = File.open("/familysub_bot/vendor/image_ids.json")
      data = JSON.load(image_ids_file)

      data[@name]
    end
  end
end
