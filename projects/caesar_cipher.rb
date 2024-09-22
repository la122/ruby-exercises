# @param string [String]
# @param shift [Integer]
def caesar_cipher(string, shift)
  string.each_byte.map do |byte|
    shifted = byte + shift
    if byte.between?(65, 90)
      shifted > 90 ? shifted % 90 + 64 : shifted
    elsif byte.between?(97, 122)
      shifted > 122 ? shifted % 122 + 96 : shifted
    else
      byte
    end.chr
  end.join
end

p caesar_cipher('What a string!', 5)
