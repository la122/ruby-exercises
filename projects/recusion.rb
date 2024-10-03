def fibs(n)
  result = []
  n.times do |i|
    result << case i
              when 0 then 0
              when 1 then 1
              else (result[-1] + result[-2])
              end
  end
  result
end

def fibs_rec(n)
  puts 'This was printed recursively'
  return [] if n.zero?
  return [0] if n == 1
  return [0, 1] if n == 2

  result = fibs_rec(n - 1)
  result << result[-1] + result[-2]
end

def merge_sort(array)
  return array if array.length < 2

  half = array.length / 2
  left = merge_sort(array[...half])
  right = merge_sort(array[half..])

  merged = []

  until left.empty? || right.empty?
    merged << if left.first < right.first
                left.shift
              else
                right.shift
              end
  end

  merged + left + right
end

n = 8
p fibs(n)
p fibs_rec(n)

p merge_sort([3, 2, 1, 13, 8, 5, 0, 1])
p merge_sort([105, 79, 100, 110])
