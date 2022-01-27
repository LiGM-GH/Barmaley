module TableUtils
  def table_line( line:           {},
                  keys:           [],
                  left_border:   "|",
                  center_border: "|",
                  right_border:  "|",
                  cover:         " ",
                  length:           )
    keys.empty? && !line.empty? &&
      raise(ArgumentError.new('Empty param :keys in tabled_line'))
    str = ''
    str += left_border
    keys.each_with_index do |key, index|
      if line.key?(key)
        str += line[key].to_s.center(length) 
      else 
        str += "".ljust(length, cover)
      end
      index == keys.length || str += center_border 
    end
    str += "\n"
  end

  def empty_line( left_border:   '|',
                  center_border: '+',
                  right_border:  '|',
                  cover:         ' ',
                  length:         10,
                  times:           1)
    str = left_border
    (times - 1).times do
      str += "".ljust(length, cover) + 
        center_border
    end
    str += "".ljust(length, cover) + right_border + "\n"
  end
end

class Table
  attr_accessor :lines, :keys, :vals, :opts
  include TableUtils
  def initialize(*args, **opts)
    @lines  = [{}]
    @opts   = opts
    add(*args)
  end

  def get_keys_vals
    @keys = []
    @vals = []
    @lines.each { |line|  @keys << line.keys
                          @vals << line.values }
    @keys.flatten! && @keys.uniq!
    @vals.flatten! && @vals.uniq!
    [@keys, @vals]
  end

  def add(*args)
    counter = ''
    args.flatten.each do |arg| 
      if arg.respond_to?(:each_pair)
        @lines << arg 
      else
        counter += arg.inspect + ' '
      end
    end
    counter.empty? || raise(ArgumentError, "Not lines of table: #{counter}")
    get_keys_vals
    @lines[0] = @keys.map { |key| [key, key] }.to_h
  end

  def set_cell_length
    defined?(@keys) || get_keys_vals
    opts[:cell_length] = [@keys, @vals].flatten\
      .max_by { |sth| sth.to_s.length }.to_s.length
  end
  
  def to_s(vertical_border: '|', horizontal_border: '-', angle: '+')
    @opts[:vertical_border  ] ||= vertical_border
    @opts[:horizontal_border] ||= horizontal_border
    @opts[:angle]             ||= angle
    border_width = opts[:vertical_border  ].chomp.length
    border_cover = opts[:horizontal_border]
    get_keys_vals
    set_cell_length
    
    str = standard_empty_line + hat + standard_empty_line
    @lines.each do |line|
      line.equal?(lines[0]) || str += standard_table_line(line)
    end
    str += standard_empty_line
  end

  def hat
    standard_table_line(@lines[0])
  end
  
  def standard_table_line(line)
    table_line(
      line:          line,
      keys:          @keys,
      length:        @opts[:cell_length],
      left_border:   @opts[:vertical_border],
      center_border: @opts[:vertical_border],
      right_border:  @opts[:vertical_border],
    )
  end
  
  def standard_empty_line
    empty_line(
      length:           @opts[:cell_length],
      times:            @keys.length,
      left_border:      @opts[:angle],
      center_border:    @opts[:angle],
      right_border:     @opts[:angle],
      cover:            @opts[:horizontal_border]
    )
  end
end
