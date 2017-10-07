require_relative 'Referee'

class AI
  
    BIGINT = 9999999 
    CUT_DEPTH = 3 #1-3 is quick. 5 is slow (within about a minute), but smart. 
                  #  Could be used as a difficulty setting
  
    def initialize(player_x = 'X', player_o = 'O', depth = 3, n2win = 4)
      @depth = depth
      @n2win = n2win
      @player_x = player_x
      @player_o = player_o
      @referee = Referee.new
      @referee.player_x = player_x
      @referee.player_o = player_o
      @referee.n2win = @n2win

      @win_referee = Referee.new(:winner)
      @win_referee.player_x = player_x
      @win_referee.player_o = player_o
      @win_referee.n2win = @n2win
    end
  
    def actions board
      actions = []
      board.width.times do |x|
        if !board.column_full? x
          actions << x
        end
      end
      actions
    end
  
    def evaluate board
      @referee.score(board)
    end
  
    def evaluate_depricated board
      x = 0
      board.each_with_index do |e, row, col|
        if e == @player_o
          x += col+1
        end
        if e == @player_x
          x -= col+1
        end
      end
      x
    end
  
    def cut_off? board,depth
      if depth >= @depth || board.full? || @win_referee.score(board) != 0
        true
      else
        false
      end
    end
  
    def next_move board
      minimax(board)[1]
    end
  
    def minimax board
      s = max_value board,nil,-BIGINT,BIGINT,0
      #puts "move #{s[1]} yields #{s[0]} points."
      s
    end
  
    def min_value board,pre_action,a,b,depth
      if cut_off?(board,depth) then return [evaluate(board),pre_action] end
  
      m = BIGINT
      actions(board).each do |action|
        new_board = board.clone
        new_board.drop_coin action, @player_x
        v = max_value(new_board,action,a,b,depth+1)[0]
        if v < m then m = v;pre_action = action end
        #if v <= a then return [v,pre_action] end
        if m < b then b = m end
      end
      [m,pre_action]
    end
  
    def max_value board,pre_action,a,b,depth
      if cut_off?(board,depth) then return [evaluate(board),pre_action] end
  
      m = -BIGINT
      actions(board).each do |action|
        new_board = board.clone
        new_board.drop_coin action, @player_o
        v = min_value(new_board,action,a,b,depth+1)[0]
        if v > m then m = v;pre_action = action end
        #if v >= b then return [v,pre_action] end
        if m > a then a = m end
      end
      [m,pre_action]
    end
  
  end