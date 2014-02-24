# this class is to parse out name, phone, email and twitter data.
require 'csv'

class Parse
  def initialize(prefixtxt, suffixtxt, inputfile, outputfile)
    @prefixtxt = prefixtxt
    @suffixtxt = suffixtxt
    @inputtxt = inputfile
    @outputtxt = outputfile
  end

  def process
    prefix_array = pre_array
    suffix_array =suf_array
    file = parse_file
    puts file.inspect
    names = parse_names(prefix_array, suffix_array, file[:name_string])
    twitter = parse_twitter(file[:twitter_handle])
    email = parse_email(file[:email_address])
    phone =parse_numbers(file[:phone_string])
    namefile = csvfile(names, phone, twitter, email)
  end

  def pre_array
    prefix_array = []
    IO.foreach(@prefixtxt) { |line| prefix_array << line.scan(/^\S*/)[0] }
    prefix_array
  end

  def suf_array
    suffix_array = []
    IO.foreach(@suffixtxt) { |line| suffix_array << line.scan(/^\S*/)[0] }
    suffix_array
  end

  def parse_file
    parsed_file = Hash.new(0)
    
    parsed_file = {name_string:[], phone_string:[], twitter_handle:[], email_address:[] }

    IO.foreach(@inputtxt) { |line| 
      parsed_file[:name_string] << line.scan(/[^\t\n]+/)[0]
      parsed_file[:phone_string] << line.scan(/[^\t\n]+/)[1]
      parsed_file[:twitter_handle] << line.scan(/[^\t\n]+/)[2]
      parsed_file[:email_address] << line.scan(/[^\t\n]+/)[3]
       }
    parsed_file
  end
  def parse_names(prefixes, suffixes, name_string)
    parsed_name = { pre: [], first: [], middle: [], last: [], suffix: [] }

    name_string.each do |w|
      word = w.scan(/([^\s]+)/).flatten
      puts "<<<<<<<"
      puts word.inspect
      if suffixes.include? word.last 
        parsed_name[:suffix] << word.pop
      else
        parsed_name[:suffix] << ''
      end
      # parsed_name[:suffix] << (suffixes.include?word.last ? word.pop : '')
      parsed_name[:last] << word.pop
     if prefixes.include? word.first
       parsed_name[:pre] << word.shift
     else
       parsed_name[:pre] << ''
     end
      # parsed_name[:pre] <<  (prefixes.include? word.first) ? word.shift : ''
      parsed_name[:first] << (word.shift || word[0] = '')
      parsed_name[:middle] << (word.shift || word[0] = '')
      puts ">>>>>"
      puts parsed_name.inspect
      parsed_name.values
      puts parsed_name.values.inspect
    end     
  end

  def parse_twitter(handle)
    twitter = /\w+/
    handle.each do |handle|
      [twitter.match(handle).to_s]
    end
  end

  def parse_email(eaddress)
    email = /\w+\@\w+\.\w+/
    eaddress.each do |eaddress|
      email.match(eaddress) ? [email.match(eaddress).to_s] : ['Not Found']
    end
  end

  def parse_numbers(numbers)
    parse_number = {  country: '', area: '', prefix: '', line: '', ext: '' }
    numbers.each do |numbers|
      num = numbers.scan(/\d+/)
      puts '<<<<<<<<<<'
      puts num.inspect
      parse_number[:country] = num.shift if num[0] == '1'
      parse_number[:area] = num.shift
      parse_number[:prefix] = num.shift
      parse_number[:line] = num.shift
      parse_number[:ext] = num.shift || num[0] = ''
      puts parse_number.values.inspect
      parse_number.values
    end
  end

  def csvfile(names, num, twit, email)
    File.open(@outputtxt, "w+") do |file|
      names.each_with_index {|v,i| 
        file.puts "#{names[i]} #{num[i]} #{twit[i]} #{email[i]}" }
    end
   end
end


#def output(histogram)
 #   File.open(@outputtxt, "w+") do |file|
  #    histogram.each { |name, count| file.puts "#{name} #{count}" }
   # end
