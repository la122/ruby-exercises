# @param prices [Array]
def stock_picker(prices)
  profit = 0
  days = [0, 0]

  prices.each_with_index do |buy_price, i|
    prices.each_with_index do |sell_price, j|
      difference = sell_price - buy_price
      if difference > profit && i < j
        profit = difference
        days = [i, j]
      end
    end
  end

  days
end

result = stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
p result
p result == [1, 4]
