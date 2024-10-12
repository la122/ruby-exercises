# @param string [String]
# @param shift [Integer]
def caesar_cipher(string, shift)
  string.each_byte.map do |byte|
    shifted = if byte.between?(65, 90)
                (byte - 65 + shift) % 26 + 65
              elsif byte.between?(97, 122)
                (byte - 97 + shift) % 26 + 97
              else
                byte
              end
    shifted.chr
  end.join
end
