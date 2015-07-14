#Main file responsible for loading other dependencies.
require 'net/http'

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
  end 


  def ip_generate(ip_v_num)
    address = ''
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
    #Create NET::HTTP request to the specified IP
    #Check response, return false for any denials, raise exceptions for incorrect/unconvertable protocols or non-existence of URL. 
    #TODO: Add IP and URL to database once established.
  end
  
  #Downloads the file from the given URL
  def pull_file(url)
   # NET::HTTP.start(@url, ) 
  end 

  private :probe, :pull_file
end
