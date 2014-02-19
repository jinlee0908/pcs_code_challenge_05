require 'spec_helper'

require 'parse.rb'

# Output the parsed data as an array of strings, just as with the names.
# # twitter name
# There are two forms:
# * @_string_
# * _string_

# For example,
# * @poohbear
# * tigger

# Strip the ampersand if present. Output the result as a single element array.
# (Note that all the parsing methods return an array,
# even if it's just one element. Why do you think this is?)

describe Parse do
  it "should accept twitter handles without ampersand" do
    return_array = Parse.parse_twitter('pluto')
    expect(return_array).to eq(['pluto'])
  end

  it "should remove amersand" do
    return_array = Parse.parse_twitter('@tiger')
    expect(return_array).to eq(['tiger'])
  end

  it "should accept words with underscores" do
    return_array = Parse.parse_twitter('@winnie_the_pooh')
    expect(return_array).to eq(['winnie_the_pooh'])
  end

  it "should accept words with mixed case letters" do
    return_array = Parse.parse_twitter('@ScroogeMcDuck')
    expect(return_array).to eq(['ScroogeMcDuck'])
  end

  it "should accept letters and numbers" do
    return_array = Parse.parse_twitter('@I3U')
    expect(return_array).to eq(['I3U'])
  end

  it "should accept only numbers" do
    return_array = Parse.parse_twitter('1234')
    expect(return_array).to eq(['1234'])
  end
end
