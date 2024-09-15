require_relative 'piece.rb'

class Board
  attr_accessor :last_move

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_grid
    @last_move = nil
  end

  def setup_grid
    @grid[0] = [Rook.new("black"), Knight.new("black"), Bishop.new("black"), Queen.new("black"), King.new("black"), Bishop.new("black"), Knight.new("black"), Rook.new("black")]
    @grid[1] = Array.new(8) { Pawn.new("black") }
    @grid[6] = Array.new(8) { Pawn.new("white") }
    @grid[7] = [Rook.new("white"), Knight.new("white"), Bishop.new("white"), Queen.new("white"), King.new("white"), Bishop.new("white"), Knight.new("white"), Rook.new("white")]
  end

  def show_board
    puts "  a b c d e f g h"
    @grid.each_with_index do |row, row_idx|
    print "#{8 - row_idx} " # Stampa i numeri delle righe
    row.each do |cell|
        if cell.nil?
        print ". "
        else
        print "#{cell.symbol} "
        end
    end
    puts "#{8 - row_idx}" # Stampa i numeri delle righe
    end
    puts "  a b c d e f g h"
  end


  def coordinate_to_indices(coordinate)
    col = coordinate[0]
    row = coordinate[1]
    col_idx = col.ord - 'a'.ord
    row_idx = 8 - row.to_i
    [row_idx, col_idx]
  end

  def indices_to_coordinate(indices)
    row, col = indices
    col_letter = (col + 'a'.ord).chr
    row_number = 8 - row	
    "#{col_letter}#{row_number}"
  end

  def move_piece(start_pos, end_pos)
    start_indices = start_pos.is_a?(Array) ? start_pos : coordinate_to_indices(start_pos)
    end_indices = end_pos.is_a?(Array) ? end_pos : coordinate_to_indices(end_pos)

    piece = @grid[start_indices[0]][start_indices[1]]
    @grid[end_indices[0]][end_indices[1]] = piece
    @grid[start_indices[0]][start_indices[1]] = nil

    @last_move = [start_indices, end_indices] # Registra l'ultima mossa

    piece.first_move = false if piece.is_a?(Pawn) # Aggiorna lo stato di primo movimento per i pedoni
  end


  def valid_move?(start_pos, end_pos, color)
    start_indices = coordinate_to_indices(start_pos)
    end_indices = coordinate_to_indices(end_pos)

    if start_indices.length != 2 || end_indices != 2
       puts "Coordinate dichiarate non valide."
       false 
    end

    piece = @grid[start_indices[0]][start_indices[1]]

    return false if piece.nil? || piece.color != color
    return false unless piece.piece_valid_move?(start_indices, end_indices, @grid)
    return false if move_puts_king_in_check?(start_indices, end_indices, color)

    true
  end

  def find_king(color)
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        return [row_idx, col_idx] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_color = color == "white" ? "black" : "white"
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        next if piece.nil? || piece.color != opponent_color
        return true if piece.piece_valid_move?([row_idx, col_idx], king_pos, @grid)
      end
    end
    false
  end

  def checkmate?(color)
    return false unless in_check?(color)
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        next if piece.nil? || piece.color != color
        (0..7).each do |end_row|
          (0..7).each do |end_col|
            next unless piece.piece_valid_move?([row_idx, col_idx], [end_row, end_col], @grid)
            temp_board = Marshal.load(Marshal.dump(self))
            temp_board.move_piece([row_idx, col_idx], [end_row, end_col])
            return false unless temp_board.in_check?(color)
          end
        end
      end
    end
    true
  end

  def move_puts_king_in_check?(start_indices, end_indices, color)
    temp_board = Marshal.load(Marshal.dump(self)) # Crea una copia profonda della scacchiera
    temp_board.move_piece(start_indices, end_indices)
    temp_board.in_check?(color)
  end
end