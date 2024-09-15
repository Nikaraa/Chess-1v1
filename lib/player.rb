class Player
  attr_reader :color, :nome
  def initialize(color)
    @color = color
    @nome = nil
  end

  def set_nome
    @nome = gets.chomp
  end
end