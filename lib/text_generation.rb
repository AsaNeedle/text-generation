require 'rspec'
require 'listen'

class TextGeneration 

  # string => array
  def clean_data (file_data)
    file_data.downcase.gsub(/[^A-Za-z0-9\s]/i, '').strip.split(" ")
  end

  # array => hash
  def create_dict(wordlist, depth)
    result = {wordlist.last(depth) => wordlist.first}
    list_len = wordlist.length
    prefix = []
    wordlist.each do |word|
      if prefix.length < depth
        prefix << word
        next
      end
      prefix_key = prefix.join(" ")
      update_arr_in_hash(result, prefix_key, word)
      prefix = update_prefix(prefix, word)
    end
    result
  end

  # array, string => array
  def update_prefix(prefix, new_word)
    new_prefix = Array.new(prefix)
    new_prefix.shift
    new_prefix << new_word
    new_prefix
  end

  # hash, string, string => change hash
  def update_arr_in_hash (hash, key, value)
    if hash.key?(key)
      hash[key] << value
    else
      hash[key] = [value]
    end
  end

  # hash, int => string
  def sentence_generator (wordbank, sen_len)
    seed = wordbank.keys.sample
    result = seed
    prefix_arr = seed.split(" ")
    sen_len.times {
      option = wordbank[prefix_arr.join(" ")].sample
      result += " #{option}"
      prefix_arr = update_prefix(prefix_arr, option)
    }
    result.capitalize + "."
  end

  # hash, int, int => string
  def paragraph_generator (wordbank, sen_len, sen_num)
    result = ""
    sen_num.times {
      sentence = sentence_generator(wordbank, sen_len)
      result += " #{sentence}"
    }
    result
  end

  # FILE, int, int, int => string
  def generate_text(file, sentence_len, sentence_num, depth)
    file_data = File.read(file)
    cleaned_text = clean_data(file_data)
    word_dict = (create_dict(cleaned_text, depth))
    return paragraph_generator(word_dict, sentence_len, sentence_num) 
  end

  def start_listener()
    listener = Listen.to(__dir__) do |added|
      sentence_len, sentence_num, depth = 10, 10, 3
      if modified.length > 0
        file = added.first
        text = generate_text(file, sentence_len, sentence_num, depth)
        puts text
      end
    end
    listener.start 
    listener.ignore /\.rb/ 
    sleep
  end


end

generator = TextGeneration.new
