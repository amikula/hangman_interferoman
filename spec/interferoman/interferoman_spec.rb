require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'interferoman/interferoman'

describe Interferoman::Interferoman do
  describe :initialize do
    it "should be instantiable with no parameters" do
      lambda { Interferoman::Interferoman.new }.should_not raise_error
    end
  end

  describe :new_game do
    it 'initializes @remaining_letters to the full alphabet' do
      subject.instance_variable_set('@remaining_letters', nil)

      subject.new_game(6)

      subject.instance_variable_get('@remaining_letters').should == ('a'..'z').to_a
    end

    it 'initializes @current_game_list to nil' do
      subject.instance_variable_set('@current_game_list', 'not nil')

      subject.new_game(6)

      subject.instance_variable_get('@current_game_list').should be_nil
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
      subject.word_list = %w{a b cd ef ghi gkl mno}
    end

    it 'initializes the list to the correct length word list' do
      subject.guess('__', 6)

      subject.instance_variable_get('@current_game_list').sort.should == %w{cd ef}
    end

    it 'removes non-matching words from its word list' do
      subject.guess('___', 6)
      subject.guess('g__', 6)

      subject.instance_variable_get('@current_game_list').sort.should == %w{ghi gkl}
    end

    it 'guesses a letter based on the length of the word' do
      guess = subject.guess('__', 6)

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

    it 'removes the guess from the list of remaining letters' do
      guess = subject.guess('__', 6)

      subject.instance_variable_get('@remaining_letters').should_not include(guess)
    end
  end

  describe :get_letter_counts do
    it 'returns an array with the counts of the number of words with each letter in the alphabet plus a placeholder 0 at the end' do
      subject.get_letter_counts(%w{abc ade fgh}).should == [2, 1, 1, 1, 1, 1, 1, 1] + [0]*19
    end
  end

  describe :best_guess do
    before :each do
      subject.instance_variable_set('@remaining_letters', ('a'..'z').to_a)
    end

    it 'returns the best letter guess, given an array of letter counts' do
      subject.best_guess([1, 0, 0, 3, 7, 3] + [0]*19 + [8] + [0]).should == 'z'
    end
  end

  describe :incorrect_guess do
    it 'removes words not containing the guess from @current_game_list' do
      subject.instance_variable_set('@current_game_list', %w{abc dcf ghi ckl mno})

      subject.incorrect_guess('c')

      subject.instance_variable_get('@current_game_list').should == %w{ghi mno}
    end
  end
end
