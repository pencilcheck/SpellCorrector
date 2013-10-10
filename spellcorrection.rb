require 'pp'

# We are assuming only three kinds of errors:
# 1. Case mismatch
# 2. Repeated letters
# 3. Incorrect vowels (we can generalize into just any letters in the word)

# Just for convenience
class String
  def remove_repeats
    self.clone.gsub(/(.)\1+/, '\1')
  end

  def star_vowels
    self.clone.gsub(/[aeiou]/, '*')
  end

  class Corrector
    attr_reader :dict_h

    def initialize(path='/usr/share/dict/words')
      dict = File.open(path).readlines.collect {|word| word.chomp}
      @dict_h = Hash.new # cluster based on three distinct errors
      dict.each do |word|
        [word, word.remove_repeats, word.remove_repeats.star_vowels].each do |id|
          if @dict_h[id]
            @dict_h[id] << word
          else
            @dict_h[id] = [word]
          end
        end
      end
    end

    # Using levenshtein distance 
    # to calculate the distance between words and then rank the suggestions 
    # based on the distance to return the most likely correct word
    # using a technique called Dynamic Programming, therefore we are going
    # to build a matrix d where d(i, j) is the distance between the first i 
    # characters of first word to the first j characters of the second word
    def levenshtein_distance(input, match)
      # Use hash instead to have O(1) insertion, deletion, access time
      matrix = Hash.new

      (input.length+1).times do |i|
        matrix[[i, 0]] = i
      end

      (match.length+1).times do |j|
        matrix[[0, j]] = j
      end

      input.each_char.with_index(1) do |c, i|
        match.each_char.with_index(1) do |m, j|
          if c.downcase == m.downcase
            matrix[[i, j]] = matrix[[i-1, j-1]]
          else
            matrix[[i, j]] = [
                    matrix[[i-1, j]]+1,   # deletion
                    matrix[[i, j-1]]+1,   # insertion
                    matrix[[i-1, j-1]]+1  # substitution
                  ].min
          end
        end
      end

      matrix[[input.length, match.length]]
    end
  end

  @@corrector = Corrector.new

  def correct
    input = self.downcase

    #puts "checking input #{input}"

    if @@corrector.dict_h.has_key? input
      d = @@corrector.dict_h[input].least_of do |word|
        @@corrector.levenshtein_distance(input, word)
      end

      return d if d
    end

    #puts "checking #{input.remove_repeats}"

    if @@corrector.dict_h.has_key? input.remove_repeats
      d = @@corrector.dict_h[input.remove_repeats].least_of do |word|
        @@corrector.levenshtein_distance(input, word)
      end

      return d if d
    end

    #puts "checking #{input.remove_repeats.star_vowels}"

    if @@corrector.dict_h.has_key? input.remove_repeats.star_vowels
      d = @@corrector.dict_h[input.remove_repeats.star_vowels].least_of do |word|
        @@corrector.levenshtein_distance(input, word)
      end

      return d if d
    end

    return 'NO SUGGESTION'
  end
end

class Array
  def least_of
    score = Float::INFINITY
    match = self.first
    self.each do |el|
      new_score = yield el
      if score > new_score
        score = new_score
        match = el
      end
    end

    match
  end
end
