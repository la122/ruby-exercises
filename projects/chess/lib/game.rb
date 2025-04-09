FILES = ('a'..'h').to_a
RANKS = ('1'..'8').to_a.reverse!

def init_board
  board = Array.new(FILES.count) { Array.new(RANKS.count, nil) }

  FILES.count.times do |j|
    board[1][j] = { piece: :pawn, color: :black }
    board[6][j] = { piece: :pawn, color: :white }
  end

  board[0][0] = { piece: :rook, color: :black }
  board[0][1] = { piece: :knight, color: :black }
  board[0][2] = { piece: :bishop, color: :black }
  board[0][3] = { piece: :queen, color: :black }
  board[0][4] = { piece: :king, color: :black }
  board[0][5] = { piece: :bishop, color: :black }
  board[0][6] = { piece: :knight, color: :black }
  board[0][7] = { piece: :rook, color: :black }

  board[7][0] = { piece: :rook, color: :white }
  board[7][1] = { piece: :knight, color: :white }
  board[7][2] = { piece: :bishop, color: :white }
  board[7][3] = { piece: :queen, color: :white }
  board[7][4] = { piece: :king, color: :white }
  board[7][5] = { piece: :bishop, color: :white }
  board[7][6] = { piece: :knight, color: :white }
  board[7][7] = { piece: :rook, color: :white }

  board
end

def render_board(board)
  puts '+ - - - - - - - - +'
  board.each_with_index do |file, i|
    print '| '
    file.each_with_index do |square, j|
      print " #{render_square(square, i, j)}"
    end
    puts "| #{RANKS[i]}"
  end
  puts '+ - - - - - - - - +'
  puts '  a b c d e f g h'
end

def render_square(square, i, j)
  print case square
        in {piece: :pawn, color: :black} then '♟'
        in {piece: :pawn, color: :white} then '♙'
        in {piece: :rook, color: :black} then '♜'
        in {piece: :rook, color: :white} then '♖'
        in {piece: :knight, color: :black} then '♞'
        in {piece: :knight, color: :white} then '♘'
        in {piece: :bishop, color: :black} then '♝'
        in {piece: :bishop, color: :white} then '♗'
        in {piece: :king, color: :black} then '♚'
        in {piece: :king, color: :white} then '♔'
        in {piece: :queen, color: :black} then '♛'
        in {piece: :queen, color: :white} then '♕'
        else (i + j).odd? ? '■' : '□'
        end
end

def read_input(player)
  puts "Player #{player}, make your move
  (e.g [a1 a2], [q] to give up)"
  gets.chomp.gsub(/\s+/, '').downcase
end

def next_player(player)
  player == :white ? :black : :white
end

def win(player)
  puts "Player #{player} wins!"
  exit
end

class InvalidMoveError < StandardError; end

def move(board, player, input)
  raise InvalidMoveError, 'Invalid input length!' if input.length != 4

  si = RANKS.index(input[1])
  sj = FILES.index(input[0])
  di = RANKS.index(input[3])
  dj = FILES.index(input[2])

  valid_fields = !si.nil? && !sj.nil? && !di.nil? && !dj.nil?
  raise InvalidMoveError, 'Invalid file or rank!' unless valid_fields

  src = board[si][sj]
  valid_src = !src.nil? && src[:color] == player
  raise InvalidMoveError, 'Please select your piece!' unless valid_src

  dest = board[di][dj]
  valid_dest = dest.nil? || dest[:color] != player
  raise InvalidMoveError, 'Cannot attack your own piece!' unless valid_dest

  unless valid_move?(board, si, sj, di, dj)
    raise InvalidMoveError,
          "A #{src[:piece]} cannot move like this!"
  end

  board[si][sj] = nil
  board[di][dj] = src

  return unless check?(board, player)

  board[si][sj] = src
  board[di][dj] = dest
  raise InvalidMoveError, 'Protect your king!'
end

def valid_move?(board, si, sj, di, dj)
  src = board[si][sj]
  dest = board[di][dj]

  case src
  in {piece: :pawn, color: :black}
    moving_forward = si + 1 == di && sj == dj && dest.nil?
    attacking = si + 1 == di && (sj - dj).abs == 1 && !dest.nil?
    two_square = si == 1 && di == 3 && sj == dj && dest.nil?
    moving_forward || attacking || two_square

  in {piece: :pawn, color: :white}
    moving_forward = si - 1 == di && sj == dj && dest.nil?
    attacking = si - 1 == di && (sj - dj).abs == 1 && !dest.nil?
    two_square = si == 6 && di == 4 && sj == dj && dest.nil?
    moving_forward || attacking || two_square

  in {piece: :rook}
    orthogonal_move?(board, si, sj, di, dj)

  in {piece: :knight}
    si, di = di, si if si > di
    sj, dj = dj, sj if sj > dj
    (si == di - 2 && sj == dj - 1) || (si == di - 1 && sj == dj - 2)

  in {piece: :bishop}
    diagonal_move?(board, si, sj, di, dj)

  in {piece: :queen}
    orthogonal_move?(board, si, sj, di, dj) ||
      diagonal_move?(board, si, sj, di, dj)

  in {piece: :king}
    (si - di).abs <= 1 && (sj - dj).abs <= 1

  else raise "Unkown piece or color: #{hash}!"
  end
end

def orthogonal_move?(board, si, sj, di, dj)
  si, di = di, si if si > di
  sj, dj = dj, sj if sj > dj
  if si != di && sj == dj
    board[(si + 1)...di].all? do |file|
      file[sj].nil?
    end
  elsif si == di && sj != dj
    board[si][sj + 1...dj].all?(nil)
  else
    false
  end
end

def diagonal_move?(board, si, sj, di, dj)
  return false unless (si - di).abs == (sj - dj).abs

  step_i = si < di ? 1 : -1
  step_j = sj < dj ? 1 : -1

  loop do
    si += step_i
    sj += step_j
    return true if si == di && sj == dj
    return false unless board[si][sj].nil?
  end
end

def check?(board, player)
  king_i = nil
  king_j = nil

  board.each_with_index do |file, i|
    file.each_with_index do |square, j|
      next unless square == { piece: :king, color: player }

      king_i = i
      king_j = j
      break
    end
  end

  board.each_with_index do |file, i|
    file.each_with_index do |square, j|
      next if square.nil? || square[:color] == player
      return true if valid_move?(board, i, j, king_i, king_j)
    end
  end

  false
end

def start_game
  board = init_board
  current_player = :white

  loop do
    render_board(board)
    input = read_input(current_player)
    win(next_player(current_player)) if input == 'q'
    begin
      move(board, current_player, input)

      current_player = next_player(current_player)
    rescue InvalidMoveError => e
      puts e.message
      next
    end
  end
end
