require_relative ".././lib/board"

describe Board do
  let(:board) {Board.new}

  describe "#grid" do
    it "returns the state of the current grid" do
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-']
      ])
    end
  end

  describe "#add" do
    it "drops a token at the specified column" do
      expect(board.add("R", 0)).to be true
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-']
      ])
    end
    it "tokens stack on top of each other on a column" do
      board.add("R", 0)
      board.add("Y", 0)
      board.add("R", 0)
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['Y', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-']
      ])
    end
    it "able to drop tokens in multiple different columns" do
      board.add("Y", 0)
      board.add("R", 1)
      board.add("Y", 2)
      board.add("R", 3)
      board.add("Y", 4)
      board.add("R", 5)
      board.add("Y", 6)
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['Y', 'R', 'Y', 'R', 'Y', 'R', 'Y']
      ])
    end
    it "does not drop a token if the specified column is already full" do
      board.add("R", 0)
      board.add("R", 0)
      board.add("R", 0)
      board.add("R", 0)
      board.add("R", 0)
      board.add("R", 0)
      expect(board.grid).to eql([
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-']
      ])
      expect(board.add("Y", 0)).to be false
      expect(board.grid).to eql([
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-'],
        ['R', '-', '-', '-', '-', '-', '-']
      ])
    end
    it "does not drop a column if the specified column is out of bounds" do
      expect(board.add("Y", -1)).to be false
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-']
      ])
      expect(board.add("Y", 7)).to be false
      expect(board.grid).to eql([
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-']
      ])
    end

  end
  describe "#check_win_condition" do
    context "Row win condition" do
      it "returns true when there are 4 of the same token in a row" do
        board.add("Y", 0)
        board.add("Y", 1)
        board.add("Y", 2)
        board.add("Y", 3)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', 'Y', 'Y', 'Y', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be true
      end
      it "returns false when there are 4 different tokens in a row" do
        board.add("Y", 0)
        board.add("R", 1)
        board.add("Y", 2)
        board.add("R", 3)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', 'R', 'Y', 'R', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be false
      end
      it "returns false when there are no 4 tokens in a row" do
        board.add("Y", 0)
        board.add("R", 1)
        board.add("Y", 3)
        board.add("Y", 4)
        board.add("Y", 5)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', 'R', '-', 'Y', 'Y', 'Y', '-']
        ])
        expect(board.check_win_condition("Y")).to be false
      end
    end
    context "Column win condition" do
      it "returns true when there are 4 of the same token in a column" do
        board.add("Y", 0)
        board.add("Y", 0)
        board.add("Y", 0)
        board.add("Y", 0)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be true
      end
      it "returns false when there are 4 different tokens in a column" do
        board.add("Y", 0)
        board.add("R", 0)
        board.add("Y", 0)
        board.add("R", 0)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['R', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-'],
          ['R', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be false
      end
      it "returns false when there are no 4 tokens in a row" do
        board.add("Y", 0)
        board.add("Y", 0)
        board.add("Y", 0)
        board.add("R", 1)
        board.add("R", 1)
        board.add("R", 1)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', 'R', '-', '-', '-', '-', '-'],
          ['Y', 'R', '-', '-', '-', '-', '-'],
          ['Y', 'R', '-', '-', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be false
      end
    end
    context "Diagonal win condition" do
      it "returns true when there are 4 of the same token in a bottom-left to top-right diagonal" do
        board.add("Y", 0)
        board.add("R", 1)
        board.add("Y", 1)
        board.add("R", 2)
        board.add("R", 2)
        board.add("Y", 2)
        board.add("Y", 3)
        board.add("Y", 3)
        board.add("R", 3)
        board.add("Y", 3)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', 'Y', '-', '-', '-'],
          ['-', '-', 'Y', 'R', '-', '-', '-'],
          ['-', 'Y', 'R', 'Y', '-', '-', '-'],
          ['Y', 'R', 'R', 'Y', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be true
      end
      it "returns true when there are 4 of the same token in a top-left to bottom-right diagonal" do
        board.add("R", 0)
        board.add("Y", 0)
        board.add("R", 0)
        board.add("Y", 0)
        board.add("Y", 1)
        board.add("R", 1)
        board.add("Y", 1)
        board.add("R", 2)
        board.add("Y", 2)
        board.add("Y", 3)
        expect(board.grid).to eql([
          ['-', '-', '-', '-', '-', '-', '-'],
          ['-', '-', '-', '-', '-', '-', '-'],
          ['Y', '-', '-', '-', '-', '-', '-'],
          ['R', 'Y', '-', '-', '-', '-', '-'],
          ['Y', 'R', 'Y', '-', '-', '-', '-'],
          ['R', 'Y', 'R', 'Y', '-', '-', '-']
        ])
        expect(board.check_win_condition("Y")).to be true
      end
    end
  end
  # Draw condition
  describe "#check_draw_condition" do
    it "returns true when the board is full and no player has won" do
      2.times do
        for col in 0..6
          if col % 2 == 0
            board.add("Y", col)
          else
            board.add("R", col)
          end
        end
        2.times do
          for col in 0..6
            if col % 2 == 0
              board.add("R", col)
            else
              board.add("Y", col)
            end
          end
        end
      end
      expect(board.grid).to eql([
        ['R', 'Y', 'R', 'Y', 'R', 'Y', 'R'],
        ['R', 'Y', 'R', 'Y', 'R', 'Y', 'R'],
        ['Y', 'R', 'Y', 'R', 'Y', 'R', 'Y'],
        ['R', 'Y', 'R', 'Y', 'R', 'Y', 'R'],
        ['R', 'Y', 'R', 'Y', 'R', 'Y', 'R'],
        ['Y', 'R', 'Y', 'R', 'Y', 'R', 'Y']
      ])
      expect(board.check_win_condition("Y")).to be false
      expect(board.check_win_condition("R")).to be false
      expect(board.check_draw_condition()).to be true
    end
    it "returns false when the board is not full" do
      expect(board.check_draw_condition()).to be false
    end
  end
end