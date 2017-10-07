require "matrix"
require "pp"

class Board < Matrix

  attr_writer :player_x, :player_o, :board

  @player_x = 'X'
  @player_o = 'O'
  @board = []

  def self.construct(width, height)
    Board.build(height,width) {"-"}
  end

  def setBoard(board, tamFila)
    if board.length > 0
      index = 0
      tamFila.times do |i|
        tamFila.times do |j|
          self[i,j] = board[index]
          index += 1
        end
      end
    end
  end

  def drop_coin column,sign
    height.times do |y|
      row = height-1-y
      if self[column,row] == "-"
        self[column,row] = sign
        break
      end
    end
  end

  def column_full? column
    height.times do |row|
      if self[column,row] == "-"
        return false
      end
    end
    return true
  end

  def full?
    width.times do |column|
      if not column_full? column
        return false
      end
    end
    return true
  end

  def []=(y,x,e)
    super(x,y,e)
  end

  def [](y,x)
    super(x,y)
  end

  def simple_render
    str = ""
    self.each_with_index do |e, row, col|
      str += "#{e}"
      if col == width-1
        str+= "\n"
      end
    end
    str
  end
  
  def render
    str = "0123456\n"
    self.each_with_index do |e, row, col|

      if e == @player_x then str+= "\e[32mX\e[0m" end
      if e == @player_o then str+= "\e[31mO\e[0m" end
      if e == '-' then str+= "-" end

      if col == width-1
        str+= "\n"
      end
    end
    str
  end

  alias_method :to_s, :render
  alias_method :width, :column_count
  alias_method :height, :row_count

end