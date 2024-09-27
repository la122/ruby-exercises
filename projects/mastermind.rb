class Game
  def initialize(codemaker, codebreaker)
    @codemaker = codemaker
    @codebreaker = codebreaker
    @max_rounds = 12
    @all_guesses = []
    @all_pegs = []
    @reveal_secret = !codebreaker.is_a?(Human)
  end

  def start
    @codemaker.choose_secret
    return if @codemaker.secret.nil?

    @max_rounds.times do |round|
      puts "Round #{round + 1}:"

      render_board

      guess = @codebreaker.guess_secret(@all_guesses, @all_pegs)
      break if guess.nil?

      @all_guesses << guess
      render_board

      pegs = @codemaker.feedback guess
      break if pegs.nil?

      @all_pegs << pegs

      if pegs == [2, 2, 2, 2]
        @reveal_secret = true
        render_board
        puts 'Codebreaker wins!'
        break
      else
        render_board
      end

      puts "Time is over! Codemaker wins!\n" if round == @max_rounds - 1
    end
  end

  private

  def render_board
    puts pretty_code(@reveal_secret ? @codemaker.secret : Array.new(4, '?'))
    puts '-' * 9

    @max_rounds.times do |index|
      puts "#{pretty_code(@all_guesses[index])} #{pretty_pegs(@all_pegs[index])}"
    end
    puts
  end

  def pretty_code(code)
    return '[_|_|_|_]' if code.nil?

    "[#{code.join('|')}]"
  end

  def pretty_pegs(pegs)
    return '[____]' if pegs.nil?

    "[#{pegs.join}]"
  end
end

class ComputerCodemaker
  attr_reader :secret

  def choose_secret
    @secret = Array.new(4) { rand(1..6) }
  end

  # @param guess [Array]
  def feedback(guess)
    pegs = []
    remaining_guess = guess.dup
    remaining_secret = @secret.dup

    guess.each_with_index do |value, index|
      next unless value == @secret[index]

      pegs << 2
      remaining_guess.delete(value)
      remaining_secret.delete(value)
    end

    remaining_guess.each do |value|
      if remaining_secret.include?(value)
        pegs << 1
        remaining_secret.delete(value)
      end
    end

    pegs << 0 while pegs.length < 4
    pegs.shuffle
  end
end

class ComputerCodebreaker
  def initialize
    @valid_numbers = [1, 2, 3, 4, 5, 6]
  end

  # @param all_guesses [Array<Array<Integer>>]
  # @param all_pegs [Array<Array<Integer>>]
  def guess_secret(all_guesses, all_pegs)
    last_pegs = all_pegs.last
    last_guess = all_guesses.last

    unless last_pegs.nil?
      @valid_numbers -= last_guess if last_pegs.sum.zero?
      @valid_numbers = last_guess unless last_pegs.include?(0)
    end

    loop do
      guess = if @valid_numbers.length == 4
                @valid_numbers.shuffle
              else
                Array.new(4, @valid_numbers.sample)
              end
      return guess unless all_guesses.include?(guess)
    end
  end

end

class WrongLengthError < StandardError; end

class WrongCodeError < StandardError; end

module Human
  def handle_input(min, max, allow = ['q'])
    input = gets.chomp
    return input if allow.include? input.downcase

    raise WrongLengthError, 'Only 4 numbers allowed!' if input.length != 4

    input.chars.map do |char|
      begin
        number = Integer(char)
        raise WrongCodeError, "Only numbers between #{min} and #{max} allowed!" if number < min || number > max

        number
      end
    rescue ArgumentError
      raise ArgumentError, "#{char} is not a valid number!"
    end

  rescue WrongLengthError, ArgumentError, WrongCodeError => e
    puts e.message
    retry
  end
end

class HumanCodemaker < ComputerCodemaker
  include Human

  def choose_secret
    puts 'Choose your secret code (e.g. 1234)'
    puts '[a] automatic | [q] quit game'

    input = handle_input(1, 6, %w[a q])

    if input == 'a'
      @secret = super
    elsif input != 'q'
      @secret = input
    end
  end

  def feedback(guess)
    puts 'Give your feedback (e.g. 0120)'
    puts '[a] automatic | [q] rage quit'

    input = handle_input(0, 2, %w[a q])
    generated_feedback = super guess

    case input
    when 'a'
      generated_feedback
    when 'q'
      nil
    else
      input
    end
  end
end

class HumanCodebreaker
  include Human

  def guess_secret(_all_guesses, _all_pegs)
    puts 'Make your guess (e.g. 1234):'
    puts '[q] rage quit'
    input = handle_input(1, 6)
    return nil if input == 'q'

    input
  end
end

loop do
  puts 'Pick your role:'
  puts '[1] Codemaker'
  puts '[2] Codebreaker'
  puts "[q] quit\n"

  case gets.chomp
  when '1'
    Game.new(HumanCodemaker.new, ComputerCodebreaker.new).start
  when '2'
    Game.new(ComputerCodemaker.new, HumanCodebreaker.new).start
  when '3'
    Game.new(ComputerCodemaker.new, ComputerCodebreaker.new).start
  when '4'
    Game.new(HumanCodemaker.new, HumanCodebreaker.new).start
  when 'q'
    return
  else
    puts 'Invalid Input!'
  end
end
