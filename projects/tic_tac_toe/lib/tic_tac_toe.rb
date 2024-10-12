class TicTacToe
  def initialize
    # @type field [Array]
    @field = Array.new(9, ' ')
    @finished = false
    @current_player = 'X'
  end

  def start
    until @finished
      render_field
      handle_input
      render_field
      evaluate
    end
  end

  def render_field
    puts " #{@field[0]} | #{@field[1]} | #{@field[2]} "
    puts ' - - - - - '
    puts " #{@field[3]} | #{@field[4]} | #{@field[5]} "
    puts ' - - - - - '
    puts " #{@field[6]} | #{@field[7]} | #{@field[8]} \n\n"
  end

  def handle_input
    puts "Player #{@current_player}, please enter a field (1-9). Enter q to give up and end the round."

    loop do
      input = gets.chomp.downcase

      if input == 'q'
        p "Player #{@current_player} gave up!"
        @finished = true
        return
      end

      spot = input.to_i

      case spot
      when 1..9
        if @field[spot - 1] != ' '
          p 'Spot is already taken! Please try again.'
        else
          p @field[spot - 1] = @current_player
          return
        end
      else
        p 'Invalid input! Please try again.'
      end
    end
  end

  def evaluate
    if (@field[0] != ' ' && @field[0] == @field[1] && @field[1] == @field[2]) ||
      (@field[3] != ' ' && @field[3] == @field[4] && @field[4] == @field[5]) ||
      (@field[6] != ' ' && @field[6] == @field[7] && @field[7] == @field[8]) ||

      (@field[0] != ' ' && @field[0] == @field[3] && @field[3] == @field[6]) ||
      (@field[1] != ' ' && @field[1] == @field[4] && @field[4] == @field[7]) ||
      (@field[2] != ' ' && @field[2] == @field[5] && @field[5] == @field[8]) ||

      (@field[0] != ' ' && @field[0] == @field[4] && @field[4] == @field[8]) ||
      (@field[2] != ' ' && @field[2] == @field[4] && @field[4] == @field[6])
      win
    elsif @field.none?(' ')
      tie
    else
      @current_player = @current_player == 'X' ? 'O' : 'X'
    end
  end

  def win
    puts "Player #{@current_player} won the game!"
    @finished = true
  end

  def tie
    puts "It's a tie!"
    @finished = true
  end
end
