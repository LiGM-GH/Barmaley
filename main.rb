#!/usr/bin/env ruby
require_relative 'get_rbs'
require 'rubyXL'
require 'rubyXL/convenience_methods'
get_rbs 'table', 'parser', from: 'program_files'

TEST_XLSX_FILE = "/home/gregory/Документы/prog/projects/"\
                  "Barmaley/tests/ruby_xl_test.xlsx"
TEST_TXT_FILE  = "/home/gregory/Документы/prog/projects/"\
                  "Barmaley/tests/test.txt"
workbook = RubyXL::Workbook.new
sheet = workbook.worksheets[0]
puts a = Table.new(Parser.new(TEST_TXT_FILE).hashes)
a.lines.each_with_index do |line, i|
  line.values.each_with_index do |value, j|
    sheet.add_cell(i, j, value)
  end
end

workbook.write(TEST_XLSX_FILE)
