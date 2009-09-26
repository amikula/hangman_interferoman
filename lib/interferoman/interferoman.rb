require 'ruby-prof'

module Interferoman
  class Interferoman
    def word_list=(list)
      @list = {}

      list.each do |word|
        (@list[word.length] ||= []) << word
      end
    end

    def new_game(*)
      @remaining_letters = [true]*26
      @current_game_list = nil
    end

    def guess(word, *)
      initialize_or_filter_game_list(word)

      guess = best_guess(get_letter_counts(@current_game_list))
      @remaining_letters[guess] = false

      (guess+?a).chr
    end

    def initialize_or_filter_game_list(word)
      if @current_game_list.nil?
        @current_game_list = @list[word.length].dup
      else
        filter_word_list(word)
      end
    end

    def filter_word_list(regexy)
      rstring = regexy.tr('_', '.')
      regex = Regexp.new("^#{rstring}$")
      @current_game_list.delete_if{|word| !regex.match(word)}
    end

    def get_letter_counts(word_array)
      counts = [0]*27

      word_array.each{|word| add_letter_counts(counts, word)}

      filter_counts(counts)
    end

    def add_letter_counts(counts, word)
      letters = word.scan(/./).uniq
      letters.each{|l| counts[l[0] - ?a] += 1}
    end

    def filter_counts(counts)
      counts.each_with_index do |count, i|
        counts[i] = 0 unless @remaining_letters[i]
      end
    end

    def best_guess(counts)
      guess_index = -1

      counts.each_with_index{|count, i| guess_index = i if counts[i] > counts[guess_index]}

      guess_index
    end

    def incorrect_guess(guess)
      @current_game_list.delete_if{|w| w.include?(guess.downcase)}
    end

    def correct_guess(*)
    end

    def fail(*)
    end

    def game_result(*)
    end
  end
end
