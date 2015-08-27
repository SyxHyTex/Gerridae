require 'net/http'
require 'uri'
require 'json'

# May need to sort this into its own file, if the number of included 
#   modules grows too large.
require_relative  'mod/helpers'

# @author Austin Schaefer <Schaefer.Austin.P@gmail.com>
class Gerridae
  extend Helpers 

  @count = 0
  class << self
    attr_accessor :count
  end
 
  # @todo review necessity for security purposes.
  IP_CONCATENATOR = '.'
  NULL_IP = '0.0.0.0'

  attr_accessor :uri, :file, :content, :has_content

  # Initialized Gerridae object with major parameters set to 0 or nil values.
  #  
  def initialize
    @file = nil

    @has_content = 0 
    @content = Hash.new

    @uri = NULL_IP

    self.class.count += 1
    # @todo Allow IP version to be changeable based on execution
  end 

  # Randomly seeds an IP address and assigns it to @see Gerridae::uri 
  # @param ip_v_num [Integer] The version of IP (4 or 6) to construct.
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

  # checks to see if the randomly generated IP is linked to a valid web domain. 
  # @param url [String] the url / IP address to visit
  def probe(url)
  # @todo Create args options Hash to dynamically configure settings.
    raise ArgumentError.new, "Incorrect number of arguments: expected 1." if url.nil? 

    # Associate argument with @uri element tag for future logging purposes.
    #   Will also serve for faster clash checking (aka w/o DBMS)
    url = URI.parse(url)

    #Create NET::HTTP request to the specified IP
    http = Net::HTTP.new(url.host, url.port)
    http.open_timeout = 3
    http.read_timeout = 3
      
    request = Net::HTTP::Get.new(url)
    request['User-Agent'] = "Gerridae Gem"
    request['Accept'] = "*/*"

    # Gather response, switch code to string, add it to content hash.
    response = http.request(request)
    code = response.code.to_s 
    @content[:return_code] = code


    # todo Abstract to own method?
    if is_good_http_response? code.to_i  
      @content[:http_version] = response.http_version
      @content[:message] = response.message
      # @todo Use JSON parsing method here
      response.each do |key, value|
        @content[key.to_sym] = value unless key.nil? && value.nil? 
      end
    end

  end
  
  # Converts hash (soon JSON file) into human-readable txt file.
  # @return [String] name of file 
  def form_file
    raise URI::InvalidURIError, 'No URI or invalid URI supplied.' if @uri.nil? || @uri.to_s.length <= 0  
    raise URI::InvalidURIError, "Invalid URI: #{@uri} supplied." unless @uri.kind_of? URI::HTTP or @uri.kind_of? URI::HTTPS

    # raise Gerridae::MissingContentError, 'No content available.' if @content.nil? || @content.length?
    # @todo Convert URI implementation to using URI::Generic.build
    
    filename = Helpers.create_filename(@uri)

    f = File.new(__dir__ + '/' +  filename, "a")

    #todo Encapsulate within try rescue block.
    IO.write( filename, @content ) if File.exist?(__dir__ + filename)
    #todo Return nil if file write fails?
    filename
  end 

  # Logs current time and string manipulates it into UNIX file friendly format. 
  # @return [String] the current time in file name friendly format.
  def parse_time
    cur_time = Time.now.to_s[0..9] + '_' + Time.now.to_s[11..18]
    cur_time.to_s
  end

  # @api private
  # Determines if provided HTML code is good or bad response.
  # @param [#to_int] HTTP response code 
  def is_good_http_response?(http_code)
    # @todo Remove exceptions, should be handled by ruby ranges during code check.
    raise ArgumentError, "Code cannot be casted to integer type." unless http_code.respond_to? :to_int 
    raise RangeError.new "Supplied code is not in valid HTTP code index." unless http_code.between? 100, 599

    code_type = (http_code / 100).floor

    # @todo Define specific code subcases within code_type cases.
    # @todo Change checking first integer index to range checking.
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
