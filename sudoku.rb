require 'debugger'
class Sudoku
  attr_reader(:board)
 
  def initialize(board)
    @board = board
  end
 
  def show
    print "\e[H\e[2J"
    numbers = @board.split('')
    two_d_arr = Array.new(9) {numbers.shift(9)}
 
    two_d_arr.each_with_index do |row, i|
      puts "+-------+-------+-------+" if i % 3 == 0
      row.each_with_index do |element, i|
        if i % 3 == 0
          print "| #{element.to_i.zero? ? " " : element} "
        else
          print "#{element.to_i.zero? ? " " : element} "
        end
      end
      print "|\n"
    end
    puts "+-------+-------+-------+"
  end
 
  def solve
    until board.include?("0") == false 
    (1..9).each do |number|
        show
        sleep(0.3)
        p "starting to solve in '#{number} Mode'..."
        sleep(0.3)
        @board = Solver.new(number, board).fill
      end 
    end
  end
end
 
 
class Solver
  BOX_OFFSET = [0, 1, 2, 9, 10, 11, 18, 19, 20]
  TOP_LEFT_OFFSET = [0, 3, 6, 27, 30, 33, 54, 57, 60]
 
  def initialize(number, string)
    @number = number
    @unsolved_string = string.dup 
    @obscured_board = obscure(string)
  end
 
  def fill    
    @board = Finder.new(@number, @obscured_board)
    (0..8).each do |position|
      if @board.row(position).one? { |number| number.to_s == "0" }  #if row has one '0'
        index = @board.row(position).index("0")
        reinsert_row_position(index, position, @number, @unsolved_string) 
      end
      if @board.col(position).one? { |number| number.to_s == "0" }
        index = @board.col(position).index("0")
        reinsert_col_position(index, position, @number, @unsolved_string)
      end
      if @board.box(position).one? { |number| number.to_s == "0" }
        index = @board.box(position).index("0")
        reinsert_box_position(index, position, @number, @unsolved_string)
      end
    end
    return @unsolved_string
  end
 
  def reinsert_row_position(relative_index, position, symbol, string)
    true_index = (position * 9) + relative_index
    string[true_index] = symbol.to_s
  end
 
  def reinsert_col_position(relative_index, position, symbol, string)
    true_index = position + (relative_index * 9)
    string[true_index] = symbol.to_s
  end
 
  def reinsert_box_position(relative_index, position, symbol, string)
    true_index = TOP_LEFT_OFFSET[position] + BOX_OFFSET[relative_index]
    string[true_index] = symbol.to_s
  end
 
  def obscure(string)
    string = string.gsub(/[^0#{@number}]/, "X")
    (0..8).each do |position|
      find = Finder.new(position, string)
      if find.row(position).include?(@number.to_s)
        (0..8).each { |relative_index| reinsert_row_position(relative_index, position, 'X', string) unless find.row(position)[relative_index] == @number.to_s }
      end
      if find.col(position).include?(@number.to_s)
        (0..8).each { |relative_index| reinsert_col_position(relative_index, position, 'X', string) unless find.col(position)[relative_index] == @number.to_s }
      end
      
      if find.box(position).include?(@number.to_s)
        (0..8).each { |relative_index| reinsert_box_position(relative_index, position, 'X', string) unless find.box(position)[relative_index] == @number.to_s }
      end
    end 
    string
  end
end
 
class Finder
 
  def initialize(number, string)
    @number = number.to_s
    @string = string
  end
 
  def row(i)
    @string.split('').each_slice(9).to_a[i]
  end
 
  def col(i)
    @string.split('').select.with_index {|char, index| (index-i) % 9 == 0 }
  end
 
  def box(i)
      top = i
      middle = i + 1
      bottom = i + 2
    if i == 0 || i == 3 || i == 6
      return row(top)[0..2] + row(middle)[0..2] + row(bottom)[0..2]
    end
    if i == 1 || i == 4 || i == 7
      top -= 1
      middle -= 1
      bottom -= 1
      return row(top)[3..5] + row(middle)[3..5] + row(bottom)[3..5]
    end
    if i == 2 || i == 5 || i == 8
      top -= 2
      middle -= 2
      bottom -= 2
      return row(top)[6..8] + row(middle)[6..8] + row(bottom)[6..8]
    end
  end
end
 
 
 
game = Sudoku.new('003020600900305001001806400008102900700000008006708200002609500800203009005010300')
game.solve

game = Sudoku.new('096040001100060004504810390007950043030080000405023018010630059059070830003590007')
game.solve

game = Sudoku.new('005030081902850060600004050007402830349760005008300490150087002090000600026049503')
game.solve

game = Sudoku.new('096040001100060004504810390007950043030080000405023018010630059059070830003590007')
game.solve

game = Sudoku.new('105802000090076405200400819019007306762083090000061050007600030430020501600308900')
game.solve

game = Sudoku.new('005030081902850060600004050007402830349760005008300490150087002090000600026049503')
game.solve

game = Sudoku.new('290500007700000400004738012902003064800050070500067200309004005000080700087005109')
game.solve

game = Sudoku.new('080020000040500320020309046600090004000640501134050700360004002407230600000700450')
game.solve

game = Sudoku.new('608730000200000460000064820080005701900618004031000080860200039050000100100456200')
game.solve

game = Sudoku.new('370000001000700005408061090000010000050090460086002030000000000694005203800149500')
game.solve

game = Sudoku.new('000689100800000029150000008403000050200005000090240801084700910500000060060410000')
game.solve

game = Sudoku.new('030500804504200010008009000790806103000005400050000007800000702000704600610300500')
game.solve

game = Sudoku.new('000075400000000008080190000300001060000000034000068170204000603900000020530200000')
game.solve #Not solved

game = Sudoku.new('300000000050703008000028070700000043000000000003904105400300800100040000968000200')
game.solve

game = Sudoku.new('302609005500730000000000900000940000000000109000057060008500006000000003019082040')
game.solve #Not solved
