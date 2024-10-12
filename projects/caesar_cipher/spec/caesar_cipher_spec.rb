# Adapted version of https://github.com/TheOdinProject/ruby_testing/blob/main/spec/16a_caesar_breaker_spec.rb

require_relative '../lib/caesar_cipher'

describe 'caesar_cipher' do
  context 'when translating one word' do
    one_word = 'Odin'

    it 'works with small positive shift' do
      small_shift = 5
      small_result = caesar_cipher(one_word, small_shift)
      expect(small_result).to eql('Tins')
    end

    it 'works with small negative shift' do
      small_negative_shift = -5
      small_negative_result = caesar_cipher(one_word, small_negative_shift)
      expect(small_negative_result).to eql('Jydi')
    end

    it 'works with large positive shift' do
      large_shift = 74
      large_result = caesar_cipher(one_word, large_shift)
      expect(large_result).to eql('Kzej')
    end

    it 'works with large negative shift' do
      large_negative_shift = -55
      large_negative_result = caesar_cipher(one_word, large_negative_shift)
      expect(large_negative_result).to eql('Lafk')
    end
  end

  context 'when translating a phrase with punctuation' do
    punctuation_phrase = 'Hello, World!'

    it 'works with small positive shift' do
      small_shift = 9
      small_result = caesar_cipher(punctuation_phrase, small_shift)
      expect(small_result).to eq('Qnuux, Fxaum!')
    end

    it 'works with small negative shift' do
      small_negative_shift = -5
      small_negative_result = caesar_cipher(punctuation_phrase, small_negative_shift)
      expect(small_negative_result).to eql('Czggj, Rjmgy!')
    end

    it 'works with large positive shift' do
      large_shift = 74
      large_result = caesar_cipher(punctuation_phrase, large_shift)
      expect(large_result).to eql('Dahhk, Sknhz!')
    end

    it 'works with large negative shift' do
      large_negative_shift = -55
      large_negative_result = caesar_cipher(punctuation_phrase, large_negative_shift)
      expect(large_negative_result).to eql('Ebiil, Tloia!')
    end
  end
end
