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
    @letters
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @valid = valid?(@word)
    @in_grid = in_the_grid?(@word, @letters)
  end

  private

  def in_the_grid?(attempt, letters)
    # letters inclue toutes les lettres de attempt
    attempt.chars.all? do |x|
      letters.count(x) >= attempt.count(x)
    end
  end

  def valid?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = URI.open(url).read
    result = JSON.parse(dictionary)
    result['found']
  end
end
