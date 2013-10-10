require_relative '../spellcorrection.rb'

describe 'Array' do
  describe 'least_of' do
    it 'returns the element with the smallest score' do
      ['1', '12', '123'].least_of {|el| el.length}.should == '1'
    end
  end
end
