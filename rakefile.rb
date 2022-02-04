# frozen_string_literal: true

require_relative 'get_rbs'

task :parser do
  get_rbs 'parser', from: 'program_files'
end

task :table do
  get_rbs 'table',  from: 'program_files'
end

task test_parser: :parser do
  puts Parser.new("#{__dir__}/tests/test.txt").get_hashes
end

task test_table: :table do
  puts Table.new({ 'Book': 'Parrot Crown',
                   'Descr': 'A humorous parrot',
                   'Author': 'Alexandro Volta' },
                 { k: 3 })
end

task get_table_from: %i[table parser] do
  table = Table.new
  Parser.new(ARGV[1]).hashes.each do |line|
    table.add(line)
  end
  puts table
end

task :main do
  get_rbs 'main'
  workbook = RubyXL::Workbook.new
  sheet = workbook.worksheets[0]
  puts a = Table.new(Parser.new(TEST_FILES[:txt]).hashes)
  a.lines.each_with_index do |line, i|
    line.values.each_with_index do |value, j|
      sheet.add_cell(i, j, value)
    end
  end

  workbook.write(TEST_FILES[:xlsx])
end
