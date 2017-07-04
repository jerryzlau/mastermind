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
    @pegs = pegs_array
  end

  def self.parse(string)
    array = string.upcase.chars
    array.map {|peg| PEGS[peg].nil? ? (raise "error") : PEGS[peg]}
    Code.new(array)
  end

  def self.random
    answer = PEGS.keys.sample(4)
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
    puts "--------------------------------------------------------"
    p @secret_code.pegs
    puts "What are your guesses? ex. R G B Y O P"
    input = gets.chomp
    if input == "tell me!"
      return "answer"
    elsif valid?(input)
      return Code.parse(input)
    else
      raise
    end

    rescue
      puts "Invalid input!"
    retry
  end

  def valid?(input)
    return false if input.length != 4
    input.upcase.chars.all? {|el| Code::PEGS.keys.include?(el)}
  end

  def display_matches(code_object)
    exact_matches = code_object.exact_matches(@secret_code)
    puts "You have #{exact_matches} exact matches."
    near_matches = code_object.near_matches(@secret_code)
    puts "And #{near_matches} near matches."
  end

  def play
    guess = ""

    100.times do
      guess = get_guess
      if guess == "answer"
        answer = @secret_code.pegs
        puts "It's a shame you gave up. Here's the answer: #{answer}."
        return
      elsif guess == @secret_code
        puts "You've got it!"
        return
      else
        puts "You didn't get it right. Here are the stats:"
        display_matches(guess)
      end
    end


  end

end

if $0 == __FILE__
  puts "Welcome to mastermind!"
  puts "Input 4 colors. ex. gggg"
  puts "Avaliable colors are R G B Y O P"
  puts "If you want to give up and get the answer, type \"tell me!\""
  Game.new.play
end
