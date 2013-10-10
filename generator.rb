dict = File.open('/usr/share/dict/words').readlines.collect {|word| word.chomp}

$max = 5
candidates = []

def cases(word)
  cands = []
  word.length.times do |i|
    cands += (0...word.length).to_a.combination(i).map do |mask|
      tmp = word.clone
      mask.each do |m|
        tmp[m] = tmp[m].upcase
      end
      tmp
    end
  end
  cands << word.upcase
  puts cands
  cands
end

def repeats(word)
  cands = []
  word.length.times do |i|
    cands += (0...word.length).to_a.combination(i).map do |mask|
      tmp = word.clone
      repeats = rand($max) + 2
      tmp.gsub!(/./) {|s| mask.include?(tmp.index(s)) ? s*repeats : s}
      tmp
    end
  end
  puts cands
  cands
end

def vowels(word)
  cands = []
  word.length.times do |i|
    cands += (0...word.length).to_a.combination(i).map do |mask|
      tmp = word.clone
      tmp.gsub!(/[aeiou]/, %w(a e i o u).sample)
      tmp
    end
  end
  puts cands
  cands
end

dict.first(10).each do |word|
  # First, CaSEs
  cases_cands = cases(word.downcase)

  # Next, rrreeepeeeaats
  repeats_cands = repeats(word)

  # Finally, vuwals error
  vowels_cands = vowels(word)

  candidates += cases_cands + repeats_cands + vowels_cands

  # A combination of errors
  (repeats_cands+vowels_cands).each do |candidate|
    candidates += cases(candidate)
  end

  #(cases_cands+vowels_cands).each do |candidate|
    #candidates += repeats(candidate)
  #end
end
