require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabets = ("A".."Z").to_a
    @time_new = Time.now
    @letters = []
    10.times { @letters << alphabets.shuffle.first }
  end

  def score
    letters = params[:token].chars
    @grid = letters.clone
    @word = params[:word].upcase
    test_word = @word.chars
    # check if the word is made up of grid
    @word.chars.each_with_index do |element, index|
      if letters.include? element
        test_word.delete_at(test_word.index(element))
        letters.delete_at(letters.index(element));
      end
    end
    return @comment = "out_of_grid" if test_word.present?
    
    # if word is created from  grid, check dictionary
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = URI.open(url).read
    word_info = JSON.parse(word_serialized)
    
    if word_info[:found]
      @comment = "valid"     
      # score
      @time_diff = (Time.now - Time.parse(params[:time]))
      @score = (5 + @word.length + (10 - @time_diff)).round
    else
      @comment = "invalid"   
    end
    # raise
  end
end
