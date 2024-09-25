# @param string [String]
# @param dictionary [Array]
def substrings(string, dictionary)
  string = string.downcase
  dictionary = dictionary.map(&:downcase)
  result = {}

  dictionary.each do |word|
    count = string.scan(word).length
    result[word] = count if count.positive?
  end

  result
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]

result = substrings('below', dictionary)
expected = { 'below' => 1, 'low' => 1 }
p result
p result == expected

result = substrings("Howdy partner, sit down! How's it going?", dictionary)
expected = { 'down' => 1, 'go' => 1, 'going' => 1, 'how' => 2, 'howdy' => 1, 'it' => 2, 'i' => 3, 'own' => 1,
             'part' => 1, 'partner' => 1, 'sit' => 1 }
p result
p result == expected
