module Helpers
 
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
end
