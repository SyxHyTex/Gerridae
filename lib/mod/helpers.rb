module Helpers
 
  IP_CONCAT = '.'

  # Formats a filename based on current operating system, in order to
  #   help log metadata and ensure unique filenames
  # @return [String] the filename to be used.
  def create_filename(uri)
    now = Time.now
    filename = uri.to_s + '_' + (now.to_s[0..9] + '_' + now.to_s[11..18]).to_s
    filename.tr!( '/', '-' )
    filename.tr!( ' ', '_' )

    filename
  end
  
  # Randomly seeds an IP address  and returns it.
  # @param ip_v_num [Integer] The version of IP (4 or 6) to construct.
  # @return [to_s] the IP address.
  def ip_generate(ip_v_num)
    raise ArgumentError, "IP version is not an integer" unless ip_v_num.is_a? Integer
    raise ArgumentError, "IP Version is not 4 or 6." unless ip_v_num == 4 || ip_v_num == 6

    address = ''

    ip_v_num.times do 
      address += rand(1..255).to_s 
      address += IP_CONCAT unless address.count(IP_CONCAT) == (ip_v_num - 1)
    end
 
    address
  end

  # Logs current time and string manipulates it into UNIX file friendly format. 
  # @return [String] the current time in file name friendly format.
  def parse_time
    cur_time = Time.now.to_s[0..9] + '_' + Time.now.to_s[11..18]
    cur_time.to_s
  end

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
  
  # Appends the first number not taken by files identically named to passed file name.
  # @param: [String] the file name to be made unique.
  # @return [String] unique file name
  def rename_duplicate(filename)
    outfile = File.expand_path( "../../out/" + filename, __FILE__ )
    dupcount = 0
    loop do 
      dupcount += 1
    break unless File.exist?(filename + dupcount.to_s)  
    end

    outfile = outfile + dupcount.to_s if dupcount > 0
    outfile
  end

  module_function :create_filename, :ip_generate, :parse_time, :is_good_http_response?, :rename_duplicate
end
