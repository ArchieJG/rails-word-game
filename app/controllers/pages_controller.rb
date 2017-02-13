require 'game.rb'

class PagesController < ApplicationController
  def game
    @grid = generate_grid(9)
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start_time])
    @grid = params[:grid].split("")

    @result = run_game(@attempt, @grid, @start_time, @end_time)

    @grid = params[:grid].split("")
    @your_word = @attempt
    @time_taken = @result[:time]
    @translation = @result[:translation]
    @score = @result[:score].round(2)
    @message = @result[:message]
  end
end
