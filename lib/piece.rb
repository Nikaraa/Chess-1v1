class Piece
  attr_reader :color
  
  def initialize(color)
    @color = color
  end
  
  def symbol
    "P" # Default symbol for a piece (will be overridden by specific pieces)
  end
end
  
class Pawn < Piece
  attr_accessor :first_move
  
  def initialize(color)
    super(color)
    @first_move = true
  end
  
  def symbol
    @color == "white" ? "P" : "p"
  end
  
  def piece_valid_move?(start_indices, end_indices, grid)
    start_row, start_col = start_indices
    end_row, end_col = end_indices
  
    if @color == "white"
      # Movimento in avanti di due caselle dalla posizione iniziale
      if @first_move && start_row == 6 && end_row == 4 && start_col == end_col
        return grid[5][start_col].nil? && grid[4][start_col].nil?
      end
        
      # Movimento in avanti di una casella
      if end_row == start_row - 1 && start_col == end_col
        return grid[end_row][end_col].nil?
      end
  
      # Movimento di cattura diagonale
      if end_row == start_row - 1 && (end_col == start_col - 1 || end_col == start_col + 1)
        return !grid[end_row][end_col].nil? && grid[end_row][end_col].color == "black"
      end
    else
      # Movimento in avanti di due caselle dalla posizione iniziale
      if @first_move && start_row == 1 && end_row == 3 && start_col == end_col
        return grid[2][start_col].nil? && grid[3][start_col].nil?
      end
  
      # Movimento in avanti di una casella
      if end_row == start_row + 1 && start_col == end_col
        return grid[end_row][end_col].nil?
      end
 
      # Movimento di cattura diagonale
      if end_row == start_row + 1 && (end_col == start_col - 1 || end_col == start_col + 1)
        return !grid[end_row][end_col].nil? && grid[end_row][end_col].color == "white"
      end
    end
  
    false
  end
end
  
class Rook < Piece
  def symbol
    @color == "white" ? "R" : "r"
  end
  
  def piece_valid_move?(start_indices, end_indices, grid)
    start_row, start_col = start_indices
    end_row, end_col = end_indices
  
    return false unless start_row == end_row || start_col == end_col
  
    if start_row == end_row
      range = start_col < end_col ? (start_col + 1...end_col) : (end_col + 1...start_col)
      range.each do |col|
        return false unless grid[start_row][col].nil?
      end
    else
      range = start_row < end_row ? (start_row + 1...end_row) : (end_row + 1...start_row)
      range.each do |row|
        return false unless grid[row][start_col].nil?
      end
    end
  
    true
  end
end
  
class Knight < Piece
  def symbol
    @color == "white" ? "N" : "n"
  end
  
  def piece_valid_move?(start_indices, end_indices, grid)
    start_row, start_col = start_indices
    end_row, end_col = end_indices
  
    row_diff = (start_row - end_row).abs
    col_diff = (start_col - end_col).abs
  
    (row_diff == 2 && col_diff == 1) || (row_diff == 1 && col_diff == 2)
  end
end
  
class Bishop < Piece
  def symbol
    @color == "white" ? "B" : "b"
  end
  
  def piece_valid_move?(start_indices, end_indices, grid)
    start_row, start_col = start_indices
    end_row, end_col = end_indices
  
    row_diff = (start_row - end_row).abs
    col_diff = (start_col - end_col).abs
  
    return false unless row_diff == col_diff
  
    row_step = start_row < end_row ? 1 : -1
    col_step = start_col < end_col ? 1 : -1
  
    (1...row_diff).each do |i|
      return false unless grid[start_row + i * row_step][start_col + i * col_step].nil?
    end

    true
  end
end
  
class Queen < Piece
  def symbol
    @color == "white" ? "Q" : "q"
  end

  def piece_valid_move?(start_indices, end_indices, grid)
    Rook.new(@color).piece_valid_move?(start_indices, end_indices, grid) ||
    Bishop.new(@color).piece_valid_move?(start_indices, end_indices, grid)
  end
end
  
class King < Piece
  def symbol
    @color == "white" ? "K" : "k"
  end
  
  def piece_valid_move?(start_indices, end_indices, grid)
    start_row, start_col = start_indices
    end_row, end_col = end_indices
  
    row_diff = (start_row - end_row).abs
    col_diff = (start_col - end_col).abs
  
    row_diff <= 1 && col_diff <= 1
  end
end