module Interferoman
  class Interferoman

    # You may initialize you player but the the initialize method must take NO paramters.
    # The player will only be instantiated once, and will play many games.
    def initialize
    end

    # Before starting a game, this method will be called to inform the player of all the possible words that may be
    # played.
    def word_list=(list)
      raise 'reset' unless @list.nil?
      @list = list.map{|w| w.downcase}
    end

    # a new game has started.  The number of guesses the player has left is passed in (default 6),
    # in case you want to keep track of it.
    def new_game(guesses_left)
      @letters = ('a'..'z').to_a
      @current_game_list = @list.dup
    end

    # Each turn your player must make a guess.  The word will be a bunch of underscores, one for each letter in the word.
    # after your first turn, correct guesses will appear in the word parameter.  If the word was "shoes" and you guessed "s",
    # the word parameter would be "s___s", if you then guess 'o', the next turn it would be "s_o_s", and so on.
    # guesses_left is how many guesses you have left before your player is hung.
    def guess(word, guesses_left)
      rstring = word.tr('_', '.')
      regex = Regexp.new("^#{rstring}$")
      @current_game_list.delete_if{|word| !regex.match(word)}

      counts = [0]*26

      @current_game_list.each do |word|
        letters = word.scan(/./).uniq
        letters.each{|l| counts[l[0] - ?a] += 1}
      end

      guess = ''
      max_count = 0
      counts.each_with_index do |count, i|
        current_letter = (i+?a).chr
        if @letters.include?(current_letter) && counts[i] > max_count
          max_count = counts[i]
          guess = current_letter
        end
      end

      @letters.delete(guess)
      guess
    end

    # notifies you that your last guess was incorrect, and passes your guess back to the method
    def incorrect_guess(guess)
      @current_game_list.delete_if{|w| w.include?(guess.downcase)}
    end

    # notifies you that your last guess was correct, and passes your guess back to the method
    def correct_guess(guess)
    end

    # you lost the game.  The reason is in the reason parameter
    def fail(reason)
    end

    # The result of the game, it'll be one of 'win', 'loss', or 'fail'.
    # The spelled out word will be provided regardless of the result.
    def game_result(result, word)
    end
  end
end
