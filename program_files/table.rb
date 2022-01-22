##
# Table class_
# Is used to build and handle tables 
class Table
  attr_accessor :lines
  def initialize(...)
    @lines = []
    lines_add_get_keys_vals
    add(...)
  end

  ##
  # Singleton method get_keys_vals for @lines
  # Returns arr of keys and arr of values
  def lines_add_get_keys_vals
    @lines.define_singleton_method(:get_keys_vals) do
      keys, vals = [], []
      each { |line| keys << line.keys
                    vals << line.values }
      [keys, vals].each { |arr| arr.flatten! && arr.uniq! }
    end
  end

  ##
  # Adds args to @lines
  def add(*args)
    counter = ''
    args.each do |arg| 
      if arg.respond_to?(:each_pair)
        @lines << arg 
      else
        counter += arg.inspect + ' '
      end
    end
    counter.empty? || raise(ArgumentError, "Not lines of table: #{counter}")
  end

  ##
  # Returns pretty formatted table.
  def to_s(vertical_border: '|', horizontal_border: '-')
    keys, vals = @lines.get_keys_vals
    border_width = vertical_border.chomp.length
    border_cover = horizontal_border
    
    # Finding lenth of columns
    cell_length = ( # max length of elem in table
      [keys, vals].flatten.max_by { |sth| sth.to_s.length }.to_s.length
    )
    
    str = ( # table's hat
      vertical_border + keys.map { |key|
        key.to_s.center(key.length + 2)\
          .center(cell_length, border_cover)
      }.join(vertical_border) + vertical_border
    )

    line_length = str.length

    str += empty_line( # Line description
      length:             cell_length,  # Some params
      times:              keys.length,  #
      left_border:    vertical_border,  #
      center_border:  vertical_border,  #
      right_border:   vertical_border,  #
      cover:        horizontal_border   # ended here
    )

    @lines.each do |line|
      str += tabled_line( # Line description
        line:                     line, # Some params
        keys:                     keys, #
        length:            cell_length, #
        cover:       horizontal_border, #
        left_border:   vertical_border, #
        center_border: vertical_border, #
        right_border:  vertical_border  # ended here
      )
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
    keys.empty? && !line.empty? &&
      raise(ArgumentError.new('Empty param :keys in tabled_line'))
    str = "\n"
    str += left_border
    keys.each_with_index do |key, index|
      str +=  if line.key?(key) 
              then line[key].to_s.center(length) 
              else "".ljust(length, cover)
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
    (times - 1).times { str += "".ljust(length, cover)
                        str += center_border           }
    str += "".ljust(length, cover)
    
    str += right_border
    str += ""
  end
end

a = Table.new({ 'Book':   'Parrot Crown', 
                'Descr':  'A humorous parrot', 
                'Author': 'Alexandro Volta'    }, 
              {k: 3})
puts a
