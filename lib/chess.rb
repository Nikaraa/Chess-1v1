require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'piece.rb'

class Chess
  def initialize
    @board = Board.new
    @player1 = Player.new("white")
    @player2 = Player.new("black")
    @player1_turn = true
    set_names
  end

  def set_names
    puts "player1, inserisci il tuo nome: "
    @player1.set_nome
    puts "player2, inserisci il tuo nome: "
    @player2.set_nome
  end
  
  def play_turn
    current_player = @player1_turn ? @player1 : @player2
    @board.show_board
    puts "#{current_player.nome}, inserisci la tua mossa (es. 'a2 a3'):"
    move = gets.chomp
    start_pos, end_pos = move.split

    if @board.valid_move?(start_pos, end_pos, current_player.color)
    start_indices = @board.coordinate_to_indices(start_pos)
    end_indices = @board.coordinate_to_indices(end_pos)

    @board.move_piece(start_pos, end_pos)

    @board.show_board

    if @board.in_check?(current_player.color)
        puts "Scacco al re #{current_player.color}!"
    end

    if @board.checkmate?(current_player.color)
        puts "Scacco matto! #{current_player.nome} ha perso!"
        return true # Fine della partita
    end
  
      @player1_turn = !@player1_turn
    else
      puts "Mossa non valida. Riprova."
    end
  
    false # La partita continua
  end

  def start_game
    loop do
      break if play_turn
    end
    puts "Partita terminata."
  end
end

chessgame = Chess.new
chessgame.start_game