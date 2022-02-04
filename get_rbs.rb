# frozen_string_literal: true

##
# Makes it easy to require

def get_rbs(*args, from: '.')
  File.directory?(from.to_s) ||
    raise(ArgumentError.new, "from: #{from} - Not a directory - \n#{from}")
  counter = []
  args.each do |arg|
    require_relative "#{from}/#{arg}"
  rescue LoadError
    counter << arg
  end
  counter.empty? || raise("Could not find #{counter.join(', ')}")
end
