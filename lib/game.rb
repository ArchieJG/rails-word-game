require 'open-uri'
require 'json'

API_KEY = "3bffc139-20e9-42a6-9185-10c15cc7be43"
URL = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{API_KEY}&input="

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  return (0...grid_size).map { ('a'..'z').to_a[rand(26)] }
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  hash_data = initial_hash(attempt, start_time, end_time)

  unless grid_check?(attempt, grid)
    hash_data = player_fail(hash_data)
    hash_data[:message] = "not in the grid"
  end

  if hash_data[:translation] == attempt
    hash_data[:message] = "not an english word"
    hash_data = player_fail(hash_data)
  end

  return hash_data
end

def player_fail(hash_data)
  hash_data[:translation] = nil
  hash_data[:score] = 0
  return hash_data
end

def initial_hash(attempt, start_time, end_time)
  working_hash = {}
  working_hash[:time] = end_time - start_time

  working_hash[:translation] = JSON.parse(open("#{URL}#{attempt}").read)["outputs"][0]["output"]
  working_hash[:score] = 10 * (attempt.length / working_hash[:time])
  working_hash[:message] = decide_message(working_hash[:score])
  return working_hash
end

def grid_check?(attempt, grid)
  match_count = 0
  attempt = attempt.downcase.split("")

  attempt.map do |char|
    if grid.include?(char)
      match_count += 1
      grid[grid.index(char)] = ""
    end
  end

  return match_count == attempt.length
end

def decide_message(score)
  if score > 10
    return "well done"
  elsif score < 10
    return "could do better"
  elsif score < 5
    return "are you even trying?"
  elsif score < 1
    return "absolutely pathetic!"
  end
end
