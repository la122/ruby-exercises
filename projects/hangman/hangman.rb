require 'json'
require_relative 'sprites'

class Game
  def initialize
    @words_file_name = 'google-10000-english-no-swears.txt'
    @save_file_name = 'save.json'
    @fails = 0
  end

  def start
    if File.exist? @save_file_name
      render_main_menu
    else
      start_new_game
    end

    until game_over?
      puts @secret_word

      render_board
      handle_user_input
      render_board
    end
  end

  def generate_secret_word
    unless File.exist?(@words_file_name)
      puts "Couldn't find #{@words_file_name}."
      return
    end

    words = File.read(@words_file_name).split
    valid_words = words.select { |w| w.length.between?(5, 12) }
    @secret_word = valid_words.sample.to_s.downcase
    puts "Couldn't find a suitable word in file #{@words_file_name}" if @secret_word.empty?
  end

  def render_main_menu
    load_from_file
    render_board

    loop do
      puts 'Welcome to Hangman!'
      puts '[c]ontinue | [n]ew game'
      input = gets.chomp.downcase
      if input == 'c'
        return
      elsif input == 'n'
        start_new_game
        return
      end
    end
  end

  def render_board
    puts HANGMAN_PICS[@fails]
    puts "#{@correct_letters.join(' ')}"
  end

  def game_over?
    if @fails == HANGMAN_PICS.length - 1
      puts "Game over! The word was #{@secret_word}"
      return true
    elsif !@correct_letters.include?('_')
      puts "#{@secret_word} is correct! You win!"
      return true
    end
    false
  end

  def handle_user_input
    puts 'Make your guess (type "qq" to quit): '
    guess = gets.chop.downcase

    if guess.match?(/\A[a-z]\z/) && @secret_word.include?(guess)
      puts 'Correct! Keep it up!'
      @secret_word.chars.each_with_index do |letter, index|
        @correct_letters[index] = letter if letter == guess
      end
    elsif guess == @secret_word
      @correct_letters = @secret_word.split('')
    elsif guess == 'qq'
      save_and_quit
    else
      @fails += 1
    end
  end

  def save_and_quit
    loop do
      puts 'Save before quit? [y]es [N]o'
      case gets.chomp
      when 'y', 'yes'
        save_to_file
        puts 'Saved!'
        exit(0)
      when 'n', 'no', ''
        exit(0)
      else
        puts 'Invalid input!'
      end
    end
  end

  def start_new_game
    generate_secret_word
    exit(1) if @secret_word.nil? || @secret_word.empty?
    @correct_letters = Array.new(@secret_word.length, '_')
    @fails = 0
  end

  def save_to_file
    string = JSON.dump({
                         secret_word: @secret_word,
                         correct_letters: @correct_letters,
                         fails: @fails,
                       })

    File.write(@save_file_name, string)
  end

  def load_from_file
    string = File.read(@save_file_name)
    data = JSON.parse string
    @secret_word = data['secret_word']
    @correct_letters = data['correct_letters']
    @fails = data['fails']
  end

end

Game.new.start
