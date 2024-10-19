require_relative 'player'

class Game
  attr_reader :board, :player1, :player2, :current_player, :last_disc

  def initialize
    @board = Array.new(6) { Array.new(7, '⚪') }
    @player1 = Player.new('Player 1', '🔴')
    @player2 = Player.new('Player 2', '🟡')
    @current_player = @player1
    @last_disc = { row: nil, column: nil }
  end

  def play
    loop do
      render_board
      move = read_player_move
      update_board(move)
      break if game_over?

      switch_player
    end
  end

  def render_board
    @board.each do |row|
      puts "#{row.join(' ')} "
    end
  end

  def read_player_move
    puts "#{@current_player.name} #{@current_player.disc} enter your move:"
    loop do
      move = gets.chomp
      return move if valid?(move)

      render_board
      puts 'Invalid move, try again:'
    end
  end

  def valid?(move)
    move = move.to_i
    move.between?(1, 7) && @board[0][move - 1] == '⚪'
  end

  def update_board(move)
    column = move.to_i - 1
    (@board.length - 1).downto(0) do |row|
      next unless @board[row][column] == '⚪'

      @board[row][column] = @current_player.disc
      @last_disc = { row: row, column: column }
      break
    end
  end

  def game_over?
    if horizontal_line? || vertical_line? || diagonal_line?
      render_board
      puts "Congratulations #{current_player.name}, you won!"
      return true
    elsif tie?
      render_board
      puts 'Its a tie!'
      return true
    end
    false
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def tie?
    @board.flatten.all? { |spot| spot != '⚪' }
  end

  def horizontal_line?
    row = @board[@last_disc[:row]]
    line?(row.join(''))
  end

  def vertical_line?
    column = @board.map { |row| row[@last_disc[:column]] }
    line?(column.join(''))
  end

  def diagonal_line?
    row = @last_disc[:row]
    column = @last_disc[:column]
    sequence1 = [@current_player.disc]
    sequence2 = [@current_player.disc]

    (1..3).each do |index|
      sequence1.append(fetch_disc(row + index, column + index))
      sequence1.prepend(fetch_disc(row - index, column - index))
      sequence2.append(fetch_disc(row - index, column + index))
      sequence2.prepend(fetch_disc(row + index, column - index))
    end

    line?(sequence1.join('')) ||
      line?(sequence2.join(''))
  end

  private

  def line?(string)
    string.include?(@current_player.disc * 4)
  end

  def fetch_disc(row, column)
    return nil if row.negative? || column.negative?

    @board.fetch(row, nil)&.fetch(column, nil)
  end
end
