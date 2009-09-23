require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'interferoman/interferoman'

describe Interferoman::Interferoman do
  describe :initialize do
    it "should be instantiable with no parameters" do
      lambda { Interferoman::Interferoman.new }.should_not raise_error
    end
  end

  describe :word_list= do
    it 'divides the words into sub-lists by word length' do
      subject.word_list = %w{a b cd efg hijkl}

      list = subject.instance_variable_get("@list")

      list[1].sort.should == %w{a b}
      list[2].should == %w{cd}
      list[3].should == %w{efg}
      (list[4] == nil || list[4].length == 0).should be_true
      list[5].should == %w{hijkl}
    end
  end

  describe :guess do
    before do
      subject.new_game(6)
      subject.word_list = %w{a b cd ef}
    end

    it 'guesses a letter based on the length of the word' do
      guess = subject.guess('..', 6)

      guess.should_not be_nil
      %w{c d e f}.should include(guess)
    end

    it 'filters out words that do not match the current word state' do
      subject.guess('__', 6)
      guess = subject.guess('_f', 6)

      guess.should == 'e'
    end

    it 'does not overwrite the original list' do
      subject.guess('__', 6)
      guess = subject.guess('_f', 6)

      subject.instance_variable_get('@list')[2].sort.should == %w{cd ef}
    end
  end
end
