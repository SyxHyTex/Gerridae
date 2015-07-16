#Main file responsible for loading other dependencies.
require 'net/http'
require 'uri'

class Gerridae

  @@swarm_count = 0
  NULL_IP = '0.0.0.0'
  IP_CONCATENATOR = '.'
  attr_accessor :file, :url 

  def initialize
    @file = nil
    @uri = NULL_IP
    @@swarm_count += 1
    #TODO: Allow IP version to be changeable based on execution

    @content = ""
  end 


  def ip_generate(ip_v_num)
    address = ''
    #TODO: Implement error throwing through wrapper objects?
    raise ArgumentError, "IP version is not an integer" unless ip_v_num.is_a? Integer
    raise ArgumentError, "IP Version is not 4 or 6." unless ip_v_num == 4 || ip_v_num == 6

    ip_v_num.times do 
      address += rand(1..255).to_s 
      address += IP_CONCATENATOR unless address.count('.') == (ip_v_num - 1)
    end
 
    @uri = address
  end

  #checks to see if the randomly generated IP is linked to a valid web domain. 
  def probe(url)
    uri = URI.parse(url)
   # throw ArgumentError, "Argument isn't a valid URL." unless uri

    #Create NET::HTTP request to the specified IP
    response = Net::HTTP.get_print(uri)

    #check status of response before reading body to prevent errors and exception crashes 
    
    #Check response, return nil for any denials, raise exceptions for incorrect/unconvertable protocols or non-existence of URL. 
    #TODO: Add IP and URL to database once established.
  end
  
  #Downloads the file from the given URL
  def form_file(content)
    filename = @uri.to_s +  
    f = file.new(filename, "w+")
    IO.write(filename, content)
  end 

  # Takes the current time, and returns it in string format, for easier file naming and database logging purposes.
  def parse_time
    now = Time.now
    cur_time = now.year + '_' now.month + '_' +
     now.day + '_' + now.hour + '_' + now.minute + '_' +  now.second
    
    cur_time.to_s
  end

  private :probe, :pull_file
end
