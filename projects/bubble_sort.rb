# @param array [Array]
def bubble_sort(array)
  loop do
    done = true
    for i in 0...(array.length - 1)
      if array[i] > array[i + 1]
        array[i], array[i + 1] = array[i + 1], array[i]
        done = false
      end
    end
    break if done
  end

  array
end

result = bubble_sort([4, 3, 78, 2, 0, 2])
p result
p result == [0, 2, 2, 3, 4, 78]