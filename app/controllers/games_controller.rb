require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    i = 0
    while i < 11
      @letters << ('A'..'Z').to_a.sample
      i += 1
    end
    return @letters
  end

  def in_the_grid?(attempt, letters)
    # letters inclue toutes les lettres de attempt
    my_word = attempt.chars.map { |letter| letter.upcase }
    my_word.all? do |x|
      letters.count(x) >= my_word.count(x)
    end
  end

  def valid?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = URI.open(url).read
    result = JSON.parse(dictionary)
    result['found']
  end

  def score
    @word = params[:word]
    @letters = params[:letters]

    if valid?(@word) && in_the_grid?(@word, @letters)
      "Congratulations! #{@word.upcase} is a valid english word."
    elsif in_the_grid?(@word, @letters) == false
      "Sorry but #{@word.upcase} can't be built out of #{@letters.join(',')}."
    else
      "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    end
  end

  # helper_method :new
  helper_method :score
end
