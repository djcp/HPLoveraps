module Hploveraps
  class DictionaryBuilder
    def initialize(dictionary_name: 'default', order: 2)
      @dictionary = MarkyMarkov::Dictionary.new(dictionary_name, order)
    end

    def parse_string(args)
      @dictionary.parse_string(args)
    end

    def parse_file(args)
      @dictionary.parse_file(args)
    end

    def save
      @dictionary.save_dictionary!
    end
  end
end
