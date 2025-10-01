class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    # Error for nvalid input
    raise ArgumentError if letter.nil? || letter.empty? || letter !~ /^[a-zA-Z]$/

    letter = letter.downcase

    # Return false when already guessed
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : '-' }.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
