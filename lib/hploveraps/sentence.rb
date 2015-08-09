module Hploveraps
  class Sentence
    attr_reader :sentence, :rhyme

    def initialize(syllables: 10, dictionary_name: 'default')
      @syllables = syllables
      @dictionary = MarkyMarkov::Dictionary.new(dictionary_name)
      @accumulated_last_words = []
      @sentence = nil
    end


    def generate
      @sentence = generate_sentence_of_x_syllables
      @rhyme_keys = @sentence.to_phrase.rhyme_keys
    end

    def generate_rhyme
      generate unless @sentence
      unless @accumulated_last_words.include?(normalize_last_word(@sentence))
        @accumulated_last_words << normalize_last_word(@sentence)
      end

      new_sentence = generate_sentence_of_x_syllables
      new_rhyme_keys = new_sentence.to_phrase.rhyme_keys

      if @rhyme_keys.include?(new_rhyme_keys.first) &&
          dont_have_same_last_words(new_sentence)
        @accumulated_last_words << normalize_last_word(new_sentence)
        @rhyme = new_sentence
        return new_sentence
      else
        generate_rhyme
      end
    end

    private

    def dont_have_same_last_words(new_sentence)
      ! @accumulated_last_words.include?(normalize_last_word(new_sentence))
    end

    def normalize_last_word(phrase)
      phrase.split(/\s+/).last.downcase.gsub(/[^a-z\d]/,'')
    end

    def generate_sentence_of_x_syllables
      word_guess = (@syllables / 1.4).to_i
      sentence = @dictionary.generate_n_words word_guess
      syllable_count = sentence.split(/\s+/).inject(0) do |sum, word|
        sum + count_syllables(word)
      end
      if syllable_count == @syllables && does_not_end_in_lame_word(sentence)
        return sentence
      else
        generate_sentence_of_x_syllables
      end
    end

    def does_not_end_in_lame_word(sentence)
      last_word = normalize_last_word(sentence)

      ! %w|a an the and or|.include?(last_word) ||
        last_word.match(/\d$/) ||
        ! last_word.to_phrase.dict?
    end

    def count_syllables(word)
      # h/t to https://stackoverflow.com/a/1272072
      word.downcase!
      return 1 if word.length <= 3
      word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
      word.sub!(/^y/, '')
      word.scan(/[aeiouy]{1,2}/).size
    end
  end
end
