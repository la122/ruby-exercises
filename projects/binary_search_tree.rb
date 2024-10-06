class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @right = right
    @left = left
  end
end

class Tree
  attr_reader :root

  def initialize(array = [])
    @root = build_tree(array.sort, 0, array.length - 1)
  end

  def build_tree(array, start_i, end_i)
    return if start_i > end_i

    mid = (start_i + end_i) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start_i, mid - 1)
    root.right = build_tree(array, mid + 1, end_i)
    root
  end

  def insert(data, root = @root)
    if root.nil?
      return Node.new(data)
    elsif data < root.data
      root.left = insert(data, root.left,)
    elsif data > root.data
      root.right = insert(data, root.right,)
    end

    root
  end

  def delete(data, root = @root)
    return root if root.nil?

    if data < root.data
      root.left = delete(data, root.left)
    elsif data > root.data
      root.right = delete(data, root.right)
    else
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      succ = successor(root)
      root.data = succ.data
      root.right = delete(succ.data, root.right)
    end
    root
  end

  def find(data, root = @root)
    return root if root.nil?

    if data < root.data
      find(data, root.left)
    elsif data > root.data
      find(data, root.right)
    else
      root
    end
  end

  def level_order(root = @root)
    return if root.nil?

    array = [] unless block_given?
    queue = [root]
    until queue.empty?
      current = queue.shift
      yield current.data if block_given?
      array << current.data unless block_given?
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end
    array unless block_given?
  end

  def inorder(root = @root, array = [], &block)
    return if root.nil?

    inorder(root.left, array, &block)
    block.call root.data if block_given?
    array << root.data unless block_given?
    inorder(root.right, array, &block)
    array unless block_given?
  end

  def preorder(root = @root, array = [], &block)
    return if root.nil?

    block.call root.data if block_given?
    array << root.data unless block_given?
    preorder(root.left, array, &block)
    preorder(root.right, array, &block)
    array unless block_given?
  end

  def postorder(root = @root, array = [], &block)
    return if root.nil?

    postorder(root.left, array, &block)
    postorder(root.right, array, &block)
    block.call root.data if block_given?
    array << root.data unless block_given?
    array unless block_given?
  end

  def height(node, count = 0, results = [])
    return count if node.nil?

    results << height(node.left, count + 1, results)
    results << height(node.right, count + 1, results)
    results.max
  end

  def depth(node, root = @root, count = 0)
    return nil if root.nil?

    if node.data < root.data
      depth(node, root.left, count + 1)
    elsif node.data > root.data
      depth(node, root.right, count + 1)
    else
      count
    end
  end

  def balanced?(root = @root)
    return true if root.nil?
    return false if (height(root.left) - height(root.right)).abs > 1

    balanced?(root.left) && balanced?(root.right)
  end

  def rebalance(root = @root)
    array = inorder(root)
    @root = build_tree(array, 0, array.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def successor(node)
    node = node.right
    node = node.left while !node.nil? && !node.left.nil?
    node
  end

end

tree = Tree.new Array.new(15) { rand(1..100) }
tree.pretty_print
puts tree.balanced?

p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

tree.insert(111)
tree.insert(222)
tree.insert(333)
tree.pretty_print
puts tree.balanced?

tree.rebalance
tree.pretty_print
puts tree.balanced?

p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
