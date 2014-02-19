# this class is to parse out name, phone, email and twitter data.
class Parse
  def self.parse_names(prefixes, suffixes, name_string)
    parsed_name = { pre: '', first: '', middle: '', last: '', suffix: '' }

    # get the last word and see if it's a suffix
    # if so, save as suffix and store the next to last word as last_name
    # otherwise store last word as last name

    word = name_string.split
    parsed_name[:suffix] = word.pop if suffixes.include? word.last
    parsed_name[:last] = word.pop
    parsed_name[:pre] = word.shift if prefixes.include? word.first
    parsed_name[:first] = word.shift || word[0] = ''
    # parsed_name[:first] = word.shift if word[0] != nil
    parsed_name[:middle] = word.shift || word[0] = ''
    # parsed_name[:middle] = word.shift if word[0] != nil
    parsed_name.values
  end

  def self.parse_twitter(data)
    twitter = /\w+/
    [twitter.match(data).to_s]
  end

  def self.parse_email(eaddress)
    email = /\w+\@\w+\.\w+/
    email.match(eaddress) ? [email.match(eaddress).to_s] : ['Not Found']
    # if address_check.match(emailaddress)
    #   valid_email = [address_check.match(emailaddress).to_s]
    # else
    #   valid_email = ['Not Found']
    # end
  end

  def self.parse_numbers(numbers)
    # sets up the hash for the funneled numbers
    parse_number = {  country: '', area: '', prefix: '', line: '', ext: '' }
    # breaks the passed number into separate strings
    num = numbers.scan(/\d+/)
    parse_number[:country] = num.shift if num[0] == '1'
    parse_number[:area] = num.shift
    parse_number[:prefix] = num.shift
    parse_number[:line] = num.shift
    parse_number[:ext] = num.shift || num[0] = ''
    # parse_number[:ext] = num.shift if num[0] != nil
    parse_number.values
  end
end
