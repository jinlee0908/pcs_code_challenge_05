#! /usr/bin/env ruby

# This script takes a required option
#  -p : find and sort prefixes by frequency of occurances
#  -s : find and sort suffixes by frequency of occurances
#
# It reads a text file from STDIN
# It writes the resulting histogram to STDOUT
class Analysis
  def self.histogram(option, txtline, outputtxt)
    case option
    when :prefix
      regular_expression = /^\S*/
    when :suffix
      regular_expression = /\S*$/
    else
      puts 'unknown option'
      puts 'usage: analyze.rb -p | -s < input_file > output_file'
      exit
    end

    histogram = Hash.new(0)

    txtline.each do |name_string|
      word = regular_expression.match(name_string).to_s
      histogram[word.to_sym] += 1
    end

    histogram = Hash[histogram.sort_by { |name, count| count }.reverse]

    File.open(outputtxt, "w+") do |file|
      histogram.each { |name, count| file.puts "#{name} #{count}" }
    end
    File.read(outputtxt)
  end
end
