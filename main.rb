#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'get_rbs'
require 'commander/import'
require 'rubyXL'
require 'rubyXL/convenience_methods'
get_rbs 'table', 'parser', 'shortcut_parser', from: 'program_files'

TEST_FILES = {
  txt: './tests/test.txt',
  pas: './tests/test.pas',
  xlsx: './tests/test.xlsx'
}.freeze

def parse_table(file)
  Table.new(Parser.new(file).hashes)
end

def table_to_sheet(table, sheet)
  table.each_cell do |value, i, j|
    sheet.add_cell(i, j, value)
  end
end

def parse_to_xlsx(*args, to:)
  workbook = 0
  args.each do |arg|
    File.exist?(arg) || raise(ArgumentError, "File #{arg} does not exist")
    workbook = RubyXL::Workbook.new
    table_to_sheet(parse_table(arg), workbook.worksheets[0])
  end
  workbook.write(to)
end

def parse_to_txt(*args, to:)
  args.each do |arg|
    next unless File.exist?(arg)

    hashes = Parser.new(arg).hashes
    File.open(to, 'a') do |file|
      file.puts(Table.new(hashes))
    end
  end
end

##
# CLI
program :name, 'Barmaley'
program :version, '1.0.0'
program :description, 'Table maker for labs'

# Let me play a while!
command :hello do |c|
  c.syntax = './main.rb hello SOMEONE'
  c.summary = 'Says hello to SOMEONE'
  c.description = 'Says hello to SOMEONE'
  c.option '--from SOMEBODY', String, 'Say hello to SOMEONE from SOMEBODY'
  c.action do |args, options|
    options.default from: nil
    if args.any?
      print 'Hello'
      print " from #{options.from}" unless options.from.nil?
      print ", #{args.join(', ')}"
    else
      print 'Hello to who?'
    end
    puts
  end
end

command :parse do |c|
  c.syntax = './main.rb parse FILE'
  c.summary = 'Finds tables in FILE'
  c.description = "Finds tables like \nhello: world\nbegin: coding\ndo: end"
  c.option '--to FILE', String, 'Print table to FILE', default: nil
  c.action do |args, options|
    options.default to: nil, as: nil
    options.to.nil? && raise(ArgumentError, "'--to' empty. What file should I write to? ")
    case File.extname(options.to)
    when '.xlsx' then parse_to_xlsx(*args, to: options.to)
    when 'txt'   then parse_to_txt(*args,  to: options.to)
    else
      raise(ArgumentError, "'--to' is not XLSX or TXT, it's #{File.extname(options.to)}")
    end
  end
end

command :shortcut_parse do |c|
  c.syntax = './main.rb shortcut_parse FILE'
  c.summary = 'Parses files to get tables with a shortcut'
  c.description = "'Class-Name-Meaning-Type-Structure-Diapazone-Format' tables are parced when given as: c name:t[diapazone](s)\"format\""
  c.option '--to FILE', String, 'Print table to FILE'
  c.action do |_args, options|
    File.open(options.to) do |file|
      table = ShortcutParser.shortcut_parse(file.read)
      
      table_to_sheet(Table.new(table), sheet)
    end
  end
end
