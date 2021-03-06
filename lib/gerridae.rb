require 'net/http'
require 'uri'
require 'json'

# May need to sort this into its own file, if the number of included 
#   modules grows too large.
require_relative  'mod/helpers'

# @author Austin Schaefer <Schaefer.Austin.P@tutanota.com>
class Gerridae
  extend Helpers 

  @count = 0
  class << self
    attr_accessor :count
  end
 
  # @todo review necessity for security purposes.
  NULL_IP = '0.0.0.0'

  attr_accessor :uri, :file, :content, :has_content

  # Initialized Gerridae object with major parameters set to 0 or nil values.
  #  
  def initialize
    @file = ''
    @content = Hash.new

    @uri = NULL_IP

    self.class.count += 1
    # @todo Allow IP version to be changeable based on execution
  end 

  # checks to see if the randomly generated IP is linked to a valid web domain. 
  # @param url [String] the url / IP address to visit
  def probe(url)
  # @todo Create args options Hash to dynamically configure settings.
    raise ArgumentError.new, "Incorrect number of arguments: expected 1." if url.nil? 

    # Associate argument with @uri element tag for future logging purposes.
    #   Will also serve for faster clash checking (aka w/o DBMS)
    url = URI.parse(url)
    @uri = url

    #Create NET::HTTP request to the specified IP
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout, http.open_timeout = 3
      
    request = Net::HTTP::Get.new(url)
    request['User-Agent'] = "Gerridae Gem"
    request['Accept'] = "*/*"
 
    # Gather response, switch code to string, add it to content hash.
    response = http.request(request)
    code = response.code.to_s 
    @content[:return_code] = code


    # todo Abstract to own method within Helpers module.
    if Helpers::is_good_http_response? code.to_i  
      @content = { :http_version => response.http_version, :message => response.message }

      # @todo Use JSON parsing method here
      response.each do |key, value|
        @content[key.to_sym] = value unless key.nil? && value.nil? 
      end
      #todo Return HTTP code to indicate success.
    end
    #todo Return nil or other failure indicator for failure.

  end
  
  # Converts content hash (soon JSON file) into human-readable txt file.
  # @return [String] name of file 
  def form_file
    raise URI::InvalidURIError, 'No URI or invalid URI supplied.' if @uri.nil? || @uri.to_s.length <= 0  
    raise URI::InvalidURIError, "Invalid URI: #{@uri} supplied." unless @uri.kind_of? URI::HTTP or @uri.kind_of? URI::HTTPS

    # raise Gerridae::MissingContentError, 'No content available.' if @content.nil? || @content.length?
    # @todo Convert URI implementation to using URI::Generic.build

    filename = Helpers.create_filename(@uri)
    outfile = File.expand_path( "../../out/" + filename, __FILE__ )
    @file = filename

    # Ensures there are no files created with precisely the same tags.
    # Helpers.rename_duplicate(parameter)
    dupcount = 0
    loop do 
      dupcount += 1
    break unless File.exist?(outfile + dupcount.to_s)  
    end

    outfile = outfile + dupcount.to_s if dupcount > 0

    File.new(outfile, "a") 

    File.open(outfile, "w") do |file|
      file.write @content
    end

    
    # @todo Encapsulate within try rescue block.
    # @todo Return nil if file write fails?
    filename
  end 
  
end
