require_relative '../lib/game'

describe Game do
  describe '#initialize' do
    subject(:game_init) { described_class.new }

    context 'when the board is created' do
      it 'has a width of 7' do
        width = 7
        actual_width = game_init.board[0].length
        expect(actual_width).to eq(width)
      end

      it 'has a height of 6' do
        height = 6
        actual_height = game_init.board.length
        expect(actual_height).to eq(height)
      end
    end
  end

  describe '#render' do
    game_board = Game.new

    context 'when board is empty' do
      empty_board = <<~HEREDOC
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
        ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪#{' '}
      HEREDOC

      it 'prints an empty board' do
        expect { game_board.render_board }.to output(empty_board).to_stdout
      end
    end
  end

  describe '#is_valid' do
    subject(:game_valid) { described_class.new }

    context 'when input is a letter' do
      it 'returns false' do
        letter = 'a'
        expect(game_valid.valid?(letter)).to be false
      end
    end

    context 'when input digit is between 1 and 7' do
      it 'returns true' do
        valid_inputs = %w[1 3 7]
        valid_inputs.each do |digit|
          expect(game_valid.valid?(digit)).to be true
        end
      end
    end

    context 'when input is out of range' do
      it 'returns false' do
        invalid_numbers = %w[0 8 10]
        invalid_numbers.each do |number|
          expect(game_valid.valid?(number)).to be false
        end
      end
    end

    context 'when first column is full' do
      before do
        board = game_valid.instance_variable_get(:@board)
        board.each_with_index do |row, index|
          row[0] = index.even? ? '🔴' : '🟡'
        end
      end

      context 'and player input is 1' do
        one = '1'
        it 'returns false' do
          expect(game_valid.valid?(one)).to be false
        end
      end

      context 'and player input is 2' do
        two = '2'
        it 'returns true' do
          expect(game_valid.valid?(two)).to be true
        end
      end
    end
  end

  describe '#update_board' do
    subject(:game_update) { described_class.new }

    context 'when column is empty' do
      it 'places the disc at the end of the column' do
        one = '1'
        board_empty = Array.new(6) { Array.new(7, '⚪') }
        board_empty[5][0] = '🔴'

        expect { game_update.update_board(one) }
          .to change(game_update, :board)
                .to(board_empty)
      end
    end

    context 'when column has one disc' do
      before do
        board = game_update.instance_variable_get(:@board)
        board[5][0] = '🟡'
      end

      it 'places the new disc on top of it' do
        one = '1'
        board_partial = Array.new(6) { Array.new(7, '⚪') }
        board_partial[5][0] = '🟡'
        board_partial[4][0] = '🔴'

        expect { game_update.update_board(one) }
          .to change(game_update, :board)
                .to(board_partial)
      end
    end
  end

  describe '#horizontal_line?' do
    subject(:game_horizontal) { described_class.new }

    context 'when there is a horizontal line of four' do
      before do
        game_horizontal.instance_variable_set(:@board, [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[🟡 🟡 🟡 🔴 🔴 🔴 🔴]
        ])
        game_horizontal.instance_variable_set(:@last_disc, { row: 4, column: 4 })
      end

      it 'returns true' do
        expect(game_horizontal).to be_horizontal_line
      end
    end
  end

  describe '#vertical_line?' do
    subject(:game_vertical) { described_class.new }

    context 'when there is a vertical line of four' do
      before do
        game_vertical.instance_variable_set(:@board, [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ 🔴 ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ 🔴 ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ 🔴 ⚪ ⚪ ⚪],
          %w[🟡 🟡 🟡 🔴 ⚪ 🔴 🔴]
        ])
        game_vertical.instance_variable_set(:@last_disc, { row: 2, column: 3 })
      end

      it 'returns true' do
        expect(game_vertical).to be_vertical_line
      end
    end
  end

  describe '#diagonal_line?' do
    subject(:game_diagonal) { described_class.new }

    context 'when there is a sinking diagonal line of four' do
      before do
        game_diagonal.instance_variable_set(:@board, [
          %w[⚪ 🟡 🟡 ⚪ 🟡 🟡 🟡],
          %w[🔴 🔴 🔴 🟡 🔴 🔴 🟡],
          %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
          %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
          %w[🟡 🟡 🟡 🔴 🟡 🟡 🟡]
        ])
        game_diagonal.instance_variable_set(:@last_disc, { row: 2, column: 1 })
      end

      it 'returns true' do
        expect(game_diagonal).to be_diagonal_line
      end
    end

    context 'when there is a raising diagonal line of four' do
      before do
        game_diagonal.instance_variable_set(:@board, [
          %w[⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪],
          %w[⚪ ⚪ ⚪ 🔴 ⚪ ⚪ ⚪],
          %w[⚪ ⚪ 🔴 🟡 ⚪ ⚪ ⚪],
          %w[⚪ 🔴 🔴 🟡 ⚪ ⚪ ⚪],
          %w[🔴 🟡 🟡 🟡 ⚪ ⚪⚪]
        ])
        game_diagonal.instance_variable_set(:@last_disc, { row: 2, column: 2 })
      end

      it 'returns true' do
        expect(game_diagonal).to be_diagonal_line
      end
    end
  end

  describe '#game_over?' do
    subject(:game_end) { described_class.new }

    context 'when there is no line of four' do
      context 'and there is empty a spot' do
        before do
          board_no_line = [
            %w[🟡 🟡 🟡 ⚪ 🟡 🟡 🟡],
            %w[🟡 🔴 🔴 🟡 🔴 🔴 🟡],
            %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
            %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
            %w[🟡 🟡 🟡 🔴 🟡 🟡 🟡]
          ]
          game_end.instance_variable_set(:@board, board_no_line)
          game_end.instance_variable_set(:@last_disc, { row: 2, column: 2 })
        end

        it 'returns false' do
          expect(game_end).not_to be_game_over
        end
      end

      context 'and board is full' do
        before do
          board_full = [
            %w[🔴 🟡 🟡 🔴 🟡 🟡 🔴],
            %w[🟡 🔴 🟡 🟡 🟡 🔴 🟡],
            %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
            %w[🔴 🔴 🔴 🟡 🔴 🔴 🔴],
            %w[🟡 🟡 🟡 🔴 🟡 🟡 🟡]
          ]
          game_end.instance_variable_set(:@board, board_full)
          game_end.instance_variable_set(:@last_disc, { row: 2, column: 2 })
        end

        it 'returns true' do
          expect(game_end).to be_game_over
        end
      end
    end
  end

  describe '#switch_player' do
    subject(:game_switch) { described_class.new }

    context 'when @current_player is Player 1' do
      it 'switches to Player 2' do
        expect { game_switch.switch_player }
          .to change { game_switch.current_player.name }
                .from('Player 1').to('Player 2')
      end
    end

    context 'when @current_player is Player 2' do
      before do
        player2 = game_switch.instance_variable_get(:@player2)
        game_switch.instance_variable_set(:@current_player, player2)
      end

      it 'switches to Player 1' do
        expect { game_switch.switch_player }
          .to change { game_switch.current_player.name }
                .from('Player 2').to('Player 1')
      end
    end
  end
end
