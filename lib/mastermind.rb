class Code
  attr_reader :pegs

  PEGS = {
    'R' => :red,
    'G' => :green,
    'B' => :blue,
    'Y' => :yellow,
    'O' => :orange,
    'P' => :purple
  }

  def initialize(pegs_array)
    pegs_array
    @pegs = pegs_array
  end

  def self.parse(string)
    array = string.upcase.chars
    array.map {|peg| PEGS[peg].nil? ? (raise "error") : PEGS[peg]}
    Code.new(array)
  end

  def self.random
    answer = []
    4.times {answer << PEGS.keys.sample}
    Code.new(answer)
  end

  def [](idx)
    @pegs[idx]
  end

  def exact_matches(code_object)
    in1 = self.pegs
    in2 = code_object.pegs
    (0..3).count {|idx| in1[idx] == in2[idx]}
  end

  def near_matches(code_object)
    in1 = self.pegs
    in2 = code_object.pegs
    exact_match = (0..3).count {|idx| in1[idx] == in2[idx]}
    (in1 & in2).size - exact_match
  end

  def ==(input)
    return false if self.class != input.class
    self.pegs == input.pegs
  end

end

class Game
  attr_reader :secret_code

  def initialize(code= Code.random)
    @secret_code = code
  end

  def get_guess
    Code.parse(@secret_code.pegs.join)
  end

  def display_matches(code_object)
    exact_matches = code_object.exact_matches(@secret_code)
    puts "exactly #{exact_matches} matches."
    near_matches = code_object.near_matches(@secret_code)
    puts "near #{near_matches} matches."
  end

end
