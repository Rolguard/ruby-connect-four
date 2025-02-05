class Board
  attr_reader(:grid)

  def initialize
    @grid = [['-', '-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-', '-']]
  end

  def display
    @grid.each {|row| puts row.join(" ")}
  end

  def add(token, column)
    # Check if column argument is out of bounds
    # Interestingly, if an index given is positively out of bounds e.g. 7
    # @grid[row][column] will return nil
    # This is because arrays in Ruby are dynamic and expand in size as you assign an element
    # E.g. a = [1, 2, 3] a[5] = 5, --> a = [1, 2, 3, nil, 5]
    # This is in contrast to most other languages which would raise an IndexError 
    # (ngl this seems like a bad feature). 
    if column < 0 || column > 6
      return false
    end

    5.downto(0) do |row|
      if @grid[row][column] == "-"
        @grid[row][column] = token
        return true
      end
    end
    return false
  end

  def check_win_condition(token)
    return check_horizontal_win?(token) || check_vertical_win?(token) || check_diagonal_win?(token)
  end

  def check_draw_condition()
    for row in 0..5
      for col in 0..6
        if @grid[row][col] == "-"
          return false
        end
      end
    end
    return true
  end

  private
  def check_horizontal_win?(token)
    # Probably inefficient to check each column index for a connect four
    # Using col 3, because 7 - 4 = 3, then you only need to count from the index
    # Can use the concept of sliding window here
    for row in 0..5 do
      token_counter = 0
      for col in 0..6 do
        if @grid[row][col] == token
          token_counter += 1

          if token_counter == 4
            return true
          end
        else
          token_counter = 0
        end
      end
    end
    return false
  end

  def check_vertical_win?(token)
    for col in 0..6 do
      token_counter = 0
      for row in 0..5 do
        if @grid[row][col] == token
          token_counter += 1

          if token_counter == 4
            return true
          end
        else
          token_counter = 0
        end
      end
    end
    return false
  end

  def check_diagonal_win?(token)
    # Check for top-left to bottom-right diagonal wins
    for row in 0..3 do
      for col in 0..4 do
        token_counter = 0
        # Keep incrementing to count number of consecutive tokens in diagonal till reach border of grid
        increment = 0
        while row + increment < 6 && col + increment < 7 do
          # puts "Looking at grid[#{row + increment}][#{col + increment}]"
          if @grid[row + increment][col + increment] == token
            # puts "Found #{token} at grid[#{row + increment}][#{col + increment}]"
            token_counter += 1
            if token_counter == 4
              return true
            end
          else
            token_counter = 0
          end
          increment += 1
        end
      end
    end

    # Check for bottom-left to top-right diagonal wins
    5.downto(3) do |row|
      for col in 0..3 do
        token_counter = 0
        increment = 0
        while row - increment > 0 && col + increment < 7 do
          if @grid[row - increment][col + increment] == token
            token_counter += 1

            if token_counter == 4
              return true
            end
          else
            token_counter = 0
          end
          increment += 1
        end
      end
    end

    return false
  end

end