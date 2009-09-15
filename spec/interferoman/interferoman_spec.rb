require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'interferoman/interferoman'

describe Interferoman::Interferoman do

  it "should be instantiable with no paramters" do

    lambda { Interferoman::Interferoman.new }.should_not raise_error

  end

end