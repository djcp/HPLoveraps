require './lib/hploveraps'
require 'find'

unless File.exists?('./default.mmd')
  dictionary_builder = Hploveraps::DictionaryBuilder.new(order: 1)
  Find.find('./corpora/lovecraft/') do |path|
    if File.file?(path)
      dictionary_builder.parse_file path
    end
  end

  dictionary_builder.save
end


while(1) do
  begin
    status = Timeout::timeout(30) do
      sentence_gen = Hploveraps::Sentence.new(syllables: 10)

      sentence_gen.generate_rhyme

      puts sentence_gen.sentence
      puts sentence_gen.rhyme

      sentence_gen.generate_rhyme
      puts sentence_gen.rhyme

      puts
    end
  rescue => e
    # puts e.inspect
    puts 'trying again'
  end
end
