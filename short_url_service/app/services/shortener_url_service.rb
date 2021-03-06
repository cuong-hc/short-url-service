class ShortenerUrlService

  def self.base62_number_to_string(number)
    #Map to store 62 possible characters 
    characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split('')  
    shorturl = "";
    # Convert given integer id to a base 62 number 
    while number > 0
      shorturl += characters[number % 62];
      number = number / 62;
    end
    return shorturl.reverse
  end

  def self.base62_string_to_number(short_url)
    number = 0;
    short_url.split('').each_with_index do |character|
      if ('a' <= character && character <= 'z') 
        number = number * 62 + character.ord - 'a'.ord
      end  
      if ('A' <= character && character <= 'Z')        
        number = number * 62 + character.ord - 'A'.ord + 26
      end
      if ('0' <= character && character <= '9')
        number = number * 62 + character.ord - '0'.ord + 52
      end
    end
    number
  end

  def self.generate_key_code_offline(from_time = DateTime.current, to_time = DateTime.current + 7)
    key_availales = []
    (from_time.to_i..to_time.to_i).to_a.each do |second|
      key_availales << {
        key_code: ShortenerUrlService.base62_number_to_string(second),
        number_to_convert: second
      }
    end
    result = key_availales.present? ? KeyAvailable.insert_all(key_availales, returning: %w[id key_code]) : []
  end

end