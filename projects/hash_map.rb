class HashMap
  Node = Struct.new(:key, :value)
  attr_reader :length

  def initialize(capacity = 16, load_factor = 0.75)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(@capacity) { [] }
    @length = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    index = hash_code % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def set(key, value)
    bucket = @buckets[hash(key)]
    found = bucket.find { |node| node.key == key }

    if found.nil?
      bucket << Node.new(key, value)
      @length += 1
      grow if @capacity * @load_factor < @length
    else
      found.value = value unless found.nil?
    end
  end

  def get(key)
    found = @buckets[hash(key)].find { |node| node.key == key }
    found&.value
  end

  def has?(key)
    @buckets[hash(key)].find { |node| node.key == key } != nil
  end

  def remove(key)
    result = get(key)
    @buckets[hash(key)].delete_if { |node| node.key == key }
    result
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @length = 0
  end

  def keys
    @buckets.flatten.map(&:key)
  end

  def values
    @buckets.flatten.map(&:value)
  end

  def entries
    @buckets.flatten.map { |node| [node.key, node.value] }
  end

  private

  def grow
    @old_buckets = @buckets.dup
    @capacity *= 2
    clear
    @old_buckets.flatten.each { |bucket| set(bucket.key, bucket.value) }
  end
end

test = HashMap.new

test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

test.set('lion', 'platinum')

test.set('moon', 'silver')

puts test.get("kite")
test.set('kite', 'magenta')
puts test.get("kite")

puts "DELETE"
puts test.remove("kite")
puts test.remove("kite")
puts test.get("kite")
