require_relative '../spellcorrection.rb'

describe 'String' do
  describe 'remove_repeats' do
    it 'removes repeats for characters' do
      'fffffddddsssss'.remove_repeats.should == 'fds'
    end

    it 'removes repeats for numbers' do
      '11112222222'.remove_repeats.should == '12'
    end

    it 'removes repeats for symbols' do
      '****####^^^'.remove_repeats.should == '*#^'
    end

    it 'removes repeats for hybrid' do
      '11112222222sdasdddddd**'.remove_repeats.should == '12sdasd*'
    end
  end

  describe 'star_vowels' do
    it 'stars vowels' do
      'aeiou'.star_vowels.should == '*****'
    end

    it 'stars vowels in mixture' do
      'aeriwwou'.star_vowels.should == '**r*ww**'
    end
  end

  describe 'correct' do
    it 'returns correction of a word with case error' do
      'inSIDE'.correct.should == 'inside'
    end

    it 'returns correction of a word with repeated error' do
      'sheeeeep'.correct.should == 'sheep'
      'jjooooobbbb'.correct.should == 'job'
    end

    it 'returns correction of a word with vowels error' do
      'weke'.correct.should == 'wake'
    end

    it 'returns correction of a word with a combination of errors' do
      'CUNsperrICY'.correct.should == 'conspiracy'
    end

    it 'returns NO SUGGESTION if there is no correction' do
      'sheeple'.correct.should == 'NO SUGGESTION'
    end
  end
end
