#! /usr/bin/env ruby

# This script takes a required option
#  -p : find and sort prefixes by frequency of occurances
#  -s : find and sort suffixes by frequency of occurances
#
# It reads a text file from STDIN
# It writes the resulting histogram to STDOUT
class Analysis
  def initialize(option, inputtxt, outputtxt)
    @option = option
    @inputtxt = inputtxt
    @outputtxt = outputtxt
  end

  def process
    txtline = name_pull
    regex = pattern
    histo = histogram(txtline,regex)
    outputfile = output(histo)
  end

  def name_pull
    parsed_names = []
    IO.foreach(@inputtxt) { |line| parsed_names << line.scan(/[^\t\n]+/)[0] }
    parsed_names
  end

  def pattern
    case @option
    when :prefix
      regular_expression = /^\S*/
    when :suffix
      regular_expression = /\S*$/
    else
      puts 'unknown option'
      puts 'usage: analyze.rb -p | -s < input_file > output_file'
      exit
    end
  end

  def histogram(txtline,regular_expression)  
    histogram = Hash.new(0)

    txtline.each do |name_string|
      word = regular_expression.match(name_string).to_s
      histogram[word.to_sym] += 1
    end
    Hash[histogram.sort_by { |name, count| count }.reverse]
  end
    
  def output(histogram)
    File.open(@outputtxt, "w+") do |file|
      histogram.each { |name, count| file.puts "#{name} #{count}" }
    end
  end
end
