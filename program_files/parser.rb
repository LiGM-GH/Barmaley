##
#* Finds hashes in given files
class Parser
  class << self
    ##
    #* makes hash from string
    def parse_hash(string)
      scanned = string.delete("\n")
      #* [Key characters]+:[Value characters]+[delimiters]
      descr_regex = 
        /[a-zA-Zа-яА-Я0-9_\s]+:[^}:]+[,}\s]/
      scanned = scanned.scan(descr_regex)
      scanned = scanned.map do |a| 
        elem = a.split(':').map { |b| b.strip }
        elem[1].delete_suffix!(',')
        elem[1].delete_suffix!('}')
        elem
      end
      scanned.to_h
    end
  end

  ##
  #* Gets file to parse hashes
  def initialize(file)
    @file = file
  end
  
  ##
  #* Gets all hashes from file
  def hashes
    hashes = []
    File.open(@file, 'r') do |file|
      last_index = 0
      until file.eof?
        begin
          file.readline('{')
          hash = parse_hash(file.readline('}'))
          hash.empty? || hashes << hash
        rescue EOFError => error
        end
      end
    end
    hashes
  end
  
  def parse_hash(string)
    self.class.parse_hash(string)
  end
end
