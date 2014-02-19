require 'spec_helper'

require 'parse.rb'

describe Parse do
  it "should parse number without country code" do
    return_array = Parse.parse_numbers('345-234-1244-x342')
    expect(return_array).to eq(['', '345', '234', '1244', '342'])
  end

  it "should parse number without an ext" do
    return_array = Parse.parse_numbers('1-345-234-1244')
    expect(return_array).to eq(['1', '345', '234', '1244', ''])
  end

  it "should parse number without country code and ext" do
    return_array = Parse.parse_numbers('345-234-1244')
    expect(return_array).to eq(['', '345', '234', '1244', ''])
  end

  it "should parse number without country code or ext" do
    return_array = Parse.parse_numbers('345-234-1244')
    expect(return_array).to eq(['', '345', '234', '1244', ''])
  end

  it "should parse number with () as a separator" do
    return_array = Parse.parse_numbers('(345)234-1244')
    expect(return_array).to eq(['', '345', '234', '1244', ''])
  end

  it "should parse number with . as a separator" do
    return_array = Parse.parse_numbers('1.345.234.1244.x345')
    expect(return_array).to eq(%w(1 345 234 1244 345))
  end

  it "should parse number with space as a separator" do
    return_array = Parse.parse_numbers('1 345 234 1244 x345')
    expect(return_array).to eq(%w(1 345 234 1244 345))
  end

  it "should parse number with ext of more than 3" do
    return_array = Parse.parse_numbers('1 345 234 1244 x34545')
    expect(return_array).to eq(%w(1 345 234 1244 34545))
  end

  it "should parse number with ext of less than 3" do
    return_array = Parse.parse_numbers('1 345 234 1244 x34')
    expect(return_array).to eq(%w(1 345 234 1244 34))
  end

  it "should parse number with ext without a leading x" do
    return_array = Parse.parse_numbers('1 345 234 1244 3434')
    expect(return_array).to eq(%w(1 345 234 1244 3434))
  end

end
