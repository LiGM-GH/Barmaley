##
# Table class_
# Is used to build and handle tables formed like
# ":class :name :meaning :type :struct :diapazone :format"

class Table
  attr_accessor :lines
  class << self
    
  end

  def initialize(*args)
    @lines = []
    args.each do |line|
      if line.respond_to?(:each_pair)
        @lines << line
      else
        raise ArgumentError, "Not a line of table: #{line.inspect}"
      end
    end
  end
  
  def add(*args)
    args.each { |arg| @lines << arg }
  end

  def to_s(vertical_border: '|', horizontal_border: '-')
    keys = []
    @lines.each do |line|
      line.each_key { |key| keys << key unless keys.include?(key) }
    end
    border_width = vertical_border.chomp.length
    border_cover = horizontal_border
    cell_length = keys.max_by { |key| key.length }.length

    table_to_s = vertical_border +
                  keys.map { |key|
                    key.to_s.center(key.length + border_width)\
                      .center(cell_length + 2 * border_width, border_cover)
                  }.join(vertical_border) +
                  vertical_border
    
    line_length = table_to_s.length
    table_to_s += "\n" + vertical_border + 
                  "".ljust(line_length - 2 * border_width, border_cover) + 
                  vertical_border + "\n"
    table_to_s
  end
end
a = Table.new({a: 2, b: 3})
puts a
