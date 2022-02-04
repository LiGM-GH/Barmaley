# frozen_string_literal: true

##
# Module TableUtils
# Handles abstract line methods
module TableUtils
  def table_line(length:, line: {},
                 keys:          [],
                 left_border:   '|',
                 center_border: '|',
                 right_border:  '|',
                 cover:         ' ')
    keys.empty? && !line.empty? && raise(ArgumentError, 'Empty param :keys in tabled_line')
    left_border +
      nonwrapped_line(line, length, keys, center_border, cover) +
      "#{right_border}\n"
  end

  def table_cell(line, key, length, cover)
    line.key?(key) ? line[key].to_s.center(length) : ''.ljust(length, cover)
  end

  def nonwrapped_line(line, length, keys, border, cover)
    keys.map { |key| table_cell(line, key, length, cover) }.join(border)
  end

  def empty_line(left_border:   '|',
                 center_border: '+',
                 right_border:  '|',
                 cover:         ' ',
                 length: 10,
                 times: 1)
    str = left_border
    (times - 1).times do
      str += ''.ljust(length, cover) +
             center_border
    end
    str += ''.ljust(length, cover) + right_border
    str += "\n"
  end
end

##
# Class Table
# Handles the creation of a table
class Table
  attr_accessor :lines, :keys, :vals, :opts

  include TableUtils
  def initialize(*args, **opts)
    @lines  = [{}]
    @opts   = opts
    add(*args)
  end

  def keys_vals
    @keys = []
    @vals = []
    @lines.each do |line|
      @keys << line.keys
      @vals << line.values
    end
    @keys.flatten! && @keys.uniq!
    @vals.flatten! && @vals.uniq!
    [@keys, @vals]
  end

  def add(*args)
    counter = ''
    args.flatten.each do |arg|
      arg.respond_to?(:each_pair) ? @lines << arg : counter += "#{arg.inspect} "
    end
    counter.empty? || raise(ArgumentError, "Not lines of table: #{counter}")
    keys_vals
    @lines[0] = @keys.map { |key| [key, key] }.to_h
  end

  def each_cell
    @lines.each_with_index do |line, i|
      line.values.each_with_index do |value, j|
        yield(value, i, j)
      end
    end
  end

  def set_cell_length
    defined?(@keys) || keys_vals
    opts[:cell_length] =
      [@keys, @vals].flatten
                    .max_by { |sth| sth.to_s.length }
                    .to_s.length
  end

  def to_s(vertical_border: '|', horizontal_border: '-', angle: '+')
    @opts[:vertical_border]   ||= vertical_border
    @opts[:horizontal_border] ||= horizontal_border
    @opts[:angle]             ||= angle
    keys_vals
    set_cell_length

    str = hat
    1.upto @lines.length - 1 do |i|
      str += standard_table_line(@lines[i])
    end
    str += standard_empty_line
  end

  def hat
    standard_empty_line + standard_table_line(@lines[0]) + standard_empty_line
  end

  def standard_table_line(line)
    table_line(
      line: line,
      keys: @keys,
      length: @opts[:cell_length],
      left_border: @opts[:vertical_border],
      center_border: @opts[:vertical_border],
      right_border: @opts[:vertical_border]
    )
  end

  def standard_empty_line
    empty_line(
      length: @opts[:cell_length],
      times: @keys.length,
      left_border: @opts[:angle],
      center_border: @opts[:angle],
      right_border: @opts[:angle],
      cover: @opts[:horizontal_border]
    )
  end
end
