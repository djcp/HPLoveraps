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
      puts 'Generating rhyme'
      sentence_gen = Hploveraps::Sentence.new(syllables: 10)
      output = ''

      sentence_gen.generate_rhyme

      output += %Q|#{sentence_gen.sentence}\n|
      output += %Q|#{sentence_gen.rhyme}\n|
      sentence_gen.generate_rhyme

      output += %Q|#{sentence_gen.rhyme}\n|

      File.open("./rhymes/lovecraft-#{Time.now.to_f}.txt", 'w') do |f|
        f.write output
      end

      puts 'Rhyme generated!'
    end
  rescue => e
    puts e.inspect
    puts 'trying again'
  end
end
