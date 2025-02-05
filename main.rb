# Connect four
# Choose Player 1 will be 'R', Player 2 will be 'Y'.
# 6 row, 7 column grid
require_relative "lib/board"
require_relative "lib/player"


def main()
  puts "Welcome to connect-four!"

  player_1 = Player.new(1, "R")
  player_2 = Player.new(2, "Y")
  puts "Player 1 will be red (R)."
  puts "Player 2 will be yellow (Y)."

  token_to_full_name = {"R" => :red, "Y" => :yellow}
  board = Board.new
  current_player = player_1
  game_over = false
  player_has_won = false
  drawn_game = false
  valid_move = false

  while !game_over
    begin
      board.display
      while !valid_move
        puts "Player #{current_player.number_id}: Please select the column to place your #{current_player.token} " \
        "token from 0 (1st column) - 6 (7th column)."
        column = Integer(gets.chomp)
        valid_move = board.add(current_player.token, column)
        if !valid_move
          puts "You cannot place a #{current_player.token} at column #{column}," \
          "as it is out of bounds or the column is full."
          board.display
        end
      end
    rescue StandardError => e
      # puts "#{e}"
      puts "Invalid input: Please type a value from 0 - 6."
      retry
    end
    # After every move, check if there is a draw or if the current player has won.
    # player_has_drawn = board.check_draw_condition(current_player.shape.value)
    player_has_won = board.check_win_condition(current_player.token)
    drawn_game = board.check_draw_condition()

    if player_has_won || drawn_game
      game_over = true
    end
    # Need to check the draw condition as well.

    if !game_over
      # Switch the player turns
      current_player == player_1 ? current_player = player_2 : current_player = player_1
      valid_move = false
    end
    
  end
  board.display
  if player_has_won
    puts "Player #{current_player.number_id} has won with " \
                    "#{token_to_full_name[current_player.token]} " \
                    "(#{current_player.token})."
  elsif drawn_game
    puts "This game is a draw."
  end
end

main()
