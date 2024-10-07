def steps(current)
  [[current.first + 1, current.last + 2],
   [current.first + 2, current.last + 1],
   [current.first - 1, current.last + 2],
   [current.first - 2, current.last + 1],
   [current.first + 1, current.last - 2],
   [current.first + 2, current.last - 1],
   [current.first - 1, current.last - 2],
   [current.first - 2, current.last - 1]]
end

def knight_moves(start, target)
  queue = [[start, [start]]]
  visited = []

  until queue.empty?
    current, path = queue.shift
    visited << current

    return path if current == target

    steps(current).select do |step|
      next if step.any? { |xy| xy.between?(0, 7) == false }
      next if visited.include?(step)

      queue << [step, path + [step]]
    end
  end
end

p knight_moves([0, 0], [1, 2])
p knight_moves([0, 0], [3, 3])
p knight_moves([3, 3], [0, 0])
p knight_moves([0, 0], [7, 7])
