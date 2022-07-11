# spec/calculator_spec.rb:
require 'rails_helper'
require 'shortener_url_service'
RSpec.describe ShortenerUrlService do
  describe '#convert_number_to_short_url' do
     it 'Convert given number to a base 62' do        
        result = ShortenerUrlService.convert_number_to_short_url(999999999)
        expect(result).to eq("bfP3Qp")
     end
  end
  describe '#convert_short_url_to_number' do
    it 'Convert short url to number' do        
       result = ShortenerUrlService.convert_short_url_to_number("bfP3Qp")
       expect(result).to eq(999999999)
    end
 end
end