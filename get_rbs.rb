##
# Makes it easy to require

def get_rbs(*args, from: '.')
  File.directory?("#{__dir__}/#{from}") || # from is directory or
  File.directory?("#{from}")            || # from is directory else
    raise(ArgumentError.new, "from: #{from} - Not a directory - \n"\
                                   "#{__dir__}/#{from}")
  args.each do |arg|
    if     File.exist?("#{from}/#{arg}") || 
           File.exist?("#{from}/#{arg}.rb")
      require_relative "#{from}/#{arg}"
    elsif  File.exist?("#{__dir__}/#{from}/#{arg}.rb") || 
           File.exist?("#{__dir__}/#{from}/#{arg}")
      require_relative "#{__dir__}/#{from}/#{arg}"
    else 
      raise("Could not find #{arg}; #{__dir__}/#{from}/#{arg}")
    end
  end
end
