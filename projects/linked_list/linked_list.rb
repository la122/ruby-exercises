class LinkedList
  attr_reader :head, :tail, :size

  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  def append(value)
    node = Node.new(value)
    if @tail.nil?
      @head = node
    else
      @tail.next_node = node
    end
    @tail = node
    @size += 1
    self
  end

  def prepend(value)
    node = Node.new(value, @head)
    if @head.nil?
      @head = node
      @tail = node
    else
      @head = node
    end
    @size += 1
    self
  end

  def at(index)
    return nil if index.abs > @size

    current = @head
    index = @size + index if index.negative?

    index.times do
      current = current.next_node
    end
    current
  end

  def pop
    return nil if @head.nil?

    popped = @tail

    if @size == 1
      @head = nil
      @tail = nil
      return popped
    end

    @size -= 1
    @tail = @head
    (@size - 1).times do
      @tail = @tail.next_node
    end
    @tail.next_node = nil
    popped
  end

  def contains?(value)
    current = @head
    return false if current.nil?

    until current.next_node.nil?
      return true if current.value == value

      current = current.next_node
    end
    false
  end

  def find(value)
    current = @head
    index = 0
    until current.nil?
      return index if current.value == value

      current = current.next_node
      index += 1
    end
  end

  def insert_at(value, index)
    index = @size + index if index.negative?
    return nil if index >= @size
    return prepend(value) if index.zero?
    return append(value) if index == size

    new_node = Node.new(value, at(index))
    previous_node = at(index - 1) unless index.zero?
    previous_node.next_node = new_node unless previous_node.nil?
    @size += 1
    self
  end

  def remove_at(index)
    index = @size + index if index.negative?
    return nil if index >= @size
    return pop if index == @size - 1

    node_to_remove = at(index)
    prev_node = at(index - 1) if index.positive?
    next_node = at(index + 1)
    prev_node.next_node = next_node if prev_node
    @head = prev_node || next_node
    @size -= 1
    node_to_remove
  end

  def to_s
    return 'nil' if @head.nil?

    @head.to_s_rest
  end
end

class Node
  attr_accessor :value, :next_node

  def initialize(value, next_node = nil)
    @value = value
    @next_node = next_node
  end

  def to_s
    value_string = @value.nil? ? 'nil' : "( #{@value} )"
    next_string = @next_node.nil? ? 'nil' : "( #{@next_node.value} )"
    "#{value_string} -> #{next_string}"
  end

  def to_s_rest
    "( #{@value} ) -> #{@next_node.nil? ? 'nil' : @next_node.to_s_rest}"
  end
end
