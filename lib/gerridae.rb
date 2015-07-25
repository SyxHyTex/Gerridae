require 'net/http'
require 'uri'
require 'json'

class Gerridae

  @count = 0
  class << self
    attr_accessor :count
  end

  NULL_IP = '0.0.0.0'
  IP_CONCATENATOR = '.'

  attr_accessor :file, :url, :file, :content 

  def initialize
    @file = nil
    @has_content = 0 
    @uri = NULL_IP

    self.class.count += 1

    #TODO: Allow IP version to be changeable based on execution

    @content = Hash.new
  end 


  def ip_generate(ip_v_num)
    address = ''
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

    # Associate argument with @uri element tag for future logging purposes.
    # Will also serve for faster clash checking (aka w/o DBMS)
    @uri = URI(url)

    #Create NET::HTTP request to the specified IP
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.open_timeout = 3
    http.read_timeout = 3
      
    #begin
    request = Net::HTTP::Get.new(@uri)
    request['User-Agent'] = "Gerridae Gem"
    request['Accept'] = "*/*"

    # Gather response, switch code to string, add it to content hash.
    response = http.request(request)
    code = response.code.to_s 
    @content[:return_code] = code

    if is_good_http_response? code.to_i  
      @content[:http_version] = response.http_version
      @content[:message] = response.message
      #TODO: Use JSON parsing method here
      response.each do |key, value|
	@content[key.to_sym] = value unless key.nil? && value.nil? 
      end
     # form_file(@content)
    end

    #TODO: Add IP and URL to database once established.
  end
  
  # Converts hash into human-readable txt file.
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
    #TODO: Remove exceptions.
    raise ArgumentError, "Code cannot be casted to integer type." unless http_code.respond_to? :to_int 
    raise RangeError.new "Supplied code is not in valid HTTP code index." unless http_code.between? 100, 599

    #TODO: Check for non HTTP code 
    code_type = (http_code / 100).floor

    # TODO: Define specific code subcases within code_type cases.
    # TODO: Change checking first integer index to range checking.
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
