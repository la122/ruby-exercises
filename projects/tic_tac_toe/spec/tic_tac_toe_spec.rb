require_relative '../lib/tic_tac_toe'

describe TicTacToe do
  describe '#handle_input' do
    subject(:game_input) { described_class.new }

    context 'when player enters "q"' do
      input = 'q'
      it 'finishes the game' do
        allow(game_input).to receive(:gets).and_return(input)
        game_input.handle_input
        finished = game_input.instance_variable_get(:@finished)
        expect(finished).to eq(true)
      end
    end

    context 'when player enters invalid number and valid number' do
      invalid_number = '10'
      valid_number = '9'

      it 'notifies player about invalid input' do
        allow(game_input).to receive(:gets).and_return(invalid_number, valid_number)
        invalid_input_message = 'Invalid input! Please try again.'
        expect { game_input.handle_input }.to output.to_stdout do |output|
          expect(output).to include(invalid_input_message)
        end
      end
    end

    context 'when player enters a taken spot and then a free one' do
      field_taken = ['X', ' ', ' ',
                     ' ', ' ', ' ',
                     ' ', ' ', ' ']
      input_taken = '1'
      input_free = '2'

      it 'notifies player that the spot is taken' do
        game_input.instance_variable_set(:@field, field_taken)
        allow(game_input).to receive(:gets).and_return(input_taken, input_free)
        spot_taken_message = 'Spot is already taken! Please try again.'
        expect { game_input.handle_input }.to output.to_stdout do |output|
          expect(output).to include(spot_taken_message)
        end
      end
    end
  end

  describe '#evaluate' do
    subject(:game_won) { described_class.new }

    context 'when there is a line of three X' do
      it 'triggers win for first row' do
        field1 = ['X', 'X', 'X',
                  ' ', ' ', ' ',
                  ' ', ' ', ' ']
        game_won.instance_variable_set(:@field, field1)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for second row' do
        field2 = [' ', ' ', ' ',
                  'X', 'X', 'X',
                  ' ', ' ', ' ']
        game_won.instance_variable_set(:@field, field2)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for third row' do
        field3 = [' ', ' ', ' ',
                  ' ', ' ', ' ',
                  'X', 'X', 'X']
        game_won.instance_variable_set(:@field, field3)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for first column' do
        field4 = ['X', ' ', ' ',
                  'X', ' ', ' ',
                  'X', ' ', ' ']
        game_won.instance_variable_set(:@field, field4)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for second column' do
        field5 = [' ', 'X', ' ',
                  ' ', 'X', ' ',
                  ' ', 'X', ' ']
        game_won.instance_variable_set(:@field, field5)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for third column' do
        field6 = [' ', ' ', 'X',
                  ' ', ' ', 'X',
                  ' ', ' ', 'X']
        game_won.instance_variable_set(:@field, field6)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for left to right diagonal' do
        field6 = ['X', ' ', ' ',
                  ' ', 'X', ' ',
                  ' ', ' ', 'X']
        game_won.instance_variable_set(:@field, field6)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end

      it 'triggers win for right to left diagonal' do
        field6 = [' ', ' ', 'X',
                  ' ', 'X', ' ',
                  'X', ' ', ' ']
        game_won.instance_variable_set(:@field, field6)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end
    end

    context 'when there is a line of three O' do
      field1 = ['O', 'O', 'O',
                ' ', ' ', ' ',
                ' ', ' ', ' ']
      it 'triggers win for first row' do
        game_won.instance_variable_set(:@field, field1)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end
    end

    context 'when the board is full' do
      it 'detects a tie' do
        field_tie = ['O', 'O', 'X',
                     'X', 'X', 'O',
                     'O', 'X', 'X']
        game_won.instance_variable_set(:@field, field_tie)
        expect(game_won).to receive(:tie)
        game_won.evaluate
      end

      it 'detects a win' do
        field_win = ['O', 'O', 'X',
                     'X', 'X', 'O',
                     'X', 'O', 'X']
        game_won.instance_variable_set(:@field, field_win)
        expect(game_won).to receive(:win)
        game_won.evaluate
      end
    end
  end
end
