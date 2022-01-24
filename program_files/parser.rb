##
# Class Parser
# Finds hashes in given files
class Parser
  def initialize(file)
    @file = file
  end
  
  def get_hashes(number: :all)
    key   = ''
    value = ''
    hashes = []
    File.open(@file, 'r') do |file|
      last_index = 0
      line = file.readline('{')
      char = ''
      key = ''
      hash = {}
      until line.nil? || file.eof?
        hash = {}
        until char.nil? || char == '}'
          char  = ''
          key   = ''
          value = ''
          until(char.nil? || char =~ /[:}]/)
            (char = file.getc).nil? || 
            (char =~ /[\n:{}]/)     || # * unless_ cycle_ended?
              key += char
          end 
          char == '}' && key = ''
          unless key.empty?
            char = ''
            until(char.nil? || char =~ /[},]/)
              (char = file.getc).nil? || 
              (char =~ /[\n:{,}]/)    || # * unless_ cycle_ended?
                value += char
            end
          end
          key.strip!
          value.strip!
          key.empty? || hash[key.dup] = value.dup
        end
        key.empty? || hashes << hash
        until char == '{' || char.nil? 
          char = file.getc
        end
      end
    end
    hashes
  end
end
