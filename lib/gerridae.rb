require 'net/http'

class Gerridae

  @@gerridae_count = 0
  NULL_IP = '0.0.0.0'
  IP_CONCATENATOR = '.'

  attr_accessor :file, :url, :file, :content 

  def initialize
    @file = nil
    @has_content = 0 
    @uri = NULL_IP

    @@gerridae_count += 1
    #TODO: Allow IP version to be changeable based on execution

    @content = Hash.new
  end 


  def ip_generate(ip_v_num)
    address = ''
    #TODO: Implement error throwing through wrapper objects?
    raise ArgumentError, "IP version is not an integer" unless ip_v_num.is_a? Integer
    raise ArgumentError, "IP Version is not 4 or 6." unless ip_v_num == 4 || ip_v_num == 6

    ip_v_num.times do 
      address += rand(1..255).to_s 
      address += IP_CONCATENATOR unless address.count(IP_CONCATENATOR) == (ip_v_num - 1)
    end
 
    @uri = address
  end

  #checks to see if the randomly generated IP is linked to a valid web domain. 
  def probe(url)
    raise ArgumentError.new, "Incorrect number of arguments: expected 1." if url.nil? 
    raise TypeError.new, "Argument #{url} can't be casted to type URI`." unless url.respond_to? URI.parse(url)

    uri = URI.parse(url)

    #Create NET::HTTP request to the specified IP
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 3
    http.read_timeout = 3
      
    #begin
    request = Net::HTTP::Get.new(uri.request_uri)
    request['User-Agent'] = "Gerridae Gem"
    request['Accept'] = "*/*"

    response = http.request(request)

    if is_good_html_response? response.code  
      response.each_header do |key, value|
	@content[key.to_sym] = value 
      end
    end

      #Check response, return nil for any denials, raise exceptions for incorrect/unconvertable protocols or non-existence of URL. 
      #TODO: Add IP and URL to database once established.
  end
  
  #Downloads the file from the given URL
  def form_file(content)
    filename = @uri.to_s + parse_time 
    f = file.new(filename, "w+")
    IO.write(filename, content)
  end 

  # Takes the current time, and returns it in string format, for easier file naming and database logging purposes.
  def parse_time
    now = Time.now
    cur_time = now.to_s[0..12] + '_' + now.to_s[14..20]
    cur_time.to_s
  end

  # Determines if provided HTML code is good or bad response.
  # Params:
  # http_code:: HTTP response code, should be of type int. 
  def is_good_http_response?(http_code)
    raise ArgumentError, "Code is not integer type." unless http_code.is_a? Integer 
    raise RangeError.new "Supplied code is not in valid HTTP code index." unless http_code.between? 100, 599

    #TODO: Check for non HTTP code 
    code_type = (http_code / 100).floor

    # TODO: Define specific code subcases within code_type cases.
    case code_type
    when 2
      true 
    when 1, 3..5
      false
    else
      false
    end

  end

end
