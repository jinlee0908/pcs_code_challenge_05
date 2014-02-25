# this class is to parse out name, phone, email and twitter data.
require 'csv'

# Parse -- It does all the interesting things
class Parse
  def initialize(prefixtxt, suffixtxt, inputfile, outputfile)
    @prefixtxt = prefixtxt
    @suffixtxt = suffixtxt
    @inputtxt = inputfile
    @outputtxt = outputfile
  end

  def process
    prefix_array = pre_array
    suffix_array = suf_array
    file = parse_file
    names = parse_names(prefix_array, suffix_array, file[:name_string])
    twitter = parse_twitter(file[:twitter_handle])
    email = parse_email(file[:email_address])
    phone = parse_numbers(file[:phone_string])
    the_whole_thing = build_csv_array(names, phone, twitter, email)
    csvfile(the_whole_thing)
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

    parsed_file = { name_string: [], phone_string: [], twitter_handle: [],
                    email_address: [] }

    IO.foreach(@inputtxt) do |line|
      parsed_file[:name_string] << line.scan(/[^\t\n]+/)[0]
      parsed_file[:phone_string] << line.scan(/[^\t\n]+/)[1]
      parsed_file[:twitter_handle] << line.scan(/[^\t\n]+/)[2]
      parsed_file[:email_address] << line.scan(/[^\t\n]+/)[3]
    end

    parsed_file
  end

  def parse_names(prefixes, suffixes, name_string)
    name_hash = { pre: '', first: '', mid: '', last: '', suf: '' }
    name_array = []
    name_string.each_with_index do |v, i|
      names = name_string[i].split
      suffixes.include?(names.last) ? name_hash[:suf] = names.pop : name_hash[:suf] = ''
      name_hash[:last] = names.pop
      prefixes.include?(names.first) ? name_hash[:pre] = names.shift : name_hash[:pre] = ''
      name_hash[:first] = (names.shift || names[0] = '')
      name_hash[:mid] = (names.shift || names[0] = '')
      name_array[i] = name_hash.values
    end
    name_array
  end

  def parse_twitter(handle)
    twitter = /\w+/
    handle.each do |tname|
      [twitter.match(tname).to_s]
    end
  end

  def parse_email(eaddress)
    email = /\w+\@\w+\.\w+/
    eaddress.each do |address|
      email.match(address) ? [email.match(address).to_s] : ['Not Found']
    end
  end

  def parse_numbers(numbers)
    parse_number = {  country: '', area: '', prefix: '', line: '', ext: '' }
    numbers.each do |phone|
      num = phone.scan(/\d+/)
      parse_number[:country] = num.shift if num[0] == '1'
      parse_number[:area] = num.shift
      parse_number[:prefix] = num.shift
      parse_number[:line] = num.shift
      parse_number[:ext] = num.shift || num[0] = ''
      parse_number.values
    end
  end

  def build_csv_array(names, number, twitter, email)
    complete_array = []
    names.each_with_index do |value, index|
      complete_array[index] = names[index]
      complete_array[index].concat([number[index]])
      complete_array[index].concat([twitter[index]])
      complete_array[index].concat([email[index]])
    end

    complete_array
  end

  def csvfile(final_data)
    CSV.open(@outputtxt, 'w') do |writer|
      writer << ['Prefix', 'First Name', 'Middle Name', 'Last Name', 'Suffix', 'Number', 'Twitter', 'Email']
      final_data.each_with_index do |value, index|
        writer << final_data[index]
      end
      puts 'FINAL DATA'
      puts final_data.inspect
    end
  end
end
 