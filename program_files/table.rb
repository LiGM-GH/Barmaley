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

  ##
  # Returns pretty formatted table.
  def to_s(vertical_border: '|', horizontal_border: '-')
    keys = []
    vals = []
    @lines.each do |line|
      line.each_pair do |key, val| 
        keys << key unless keys.include?(key)
        vals << val unless vals.include?(val)
      end
    end
    border_width = vertical_border.chomp.length
    border_cover = horizontal_border
    cell_length_keys = keys.max_by { |key| key.length }.length + 2 * border_width
    cell_length_vals = vals.max_by { |val| val.to_s.length }.length + 2 * border_width
    cell_length = [cell_length_vals, cell_length_keys].max
    str = vertical_border +
                  keys.map { |key|
                    key.to_s.center(key.length + 2 * border_width)\
                      .center(cell_length, border_cover)
                  }.join(vertical_border) +
                  vertical_border

    line_length = str.length

    str += empty_line(length:             cell_length,
                      left_border:    vertical_border,
                      center_border:  vertical_border,
                      right_border:   vertical_border,
                      cover:        horizontal_border,
                      times:              keys.length)
    @lines.each_with_index do |line, i|
      str += tabled_line(line: line, keys: keys, length: cell_length)
    end
    str
  end

  def tabled_line(line:           {},
                  keys:           [],
                  left_border:   "|",
                  center_border: "|",
                  right_border:  "|",
                  cover:         "-",
                  length:         10)
    keys.empty? && raise(ArgumentError.new('Empty param :keys in tabled_line'))
    str = "\n"
    str += left_border
    keys.each_with_index do |key, index|
      if line.key?(key)
        str += line[key].to_s.center(length)
      else
        str += "".ljust(length, cover)
      end
      index == keys.length || str += center_border 
    end
    str += ""
  end

  def empty_line( left_border:   '|',
                  center_border: '|',
                  right_border:  '|',
                  cover:         '-',
                  length:         10,
                  times:           1)
    str = "\n"
    str += left_border
    (times - 1).times do
      str += "".ljust(length, cover)
      str += center_border
    end
    str += "".ljust(length, cover)
    
    str += right_border
    str += ""
  end
end
puts Table.new({a: 2, b: 3, c: 'Alexandro'}, {k: 3})
