#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'get_rbs'
require 'commander/import'
require 'rubyXL'
require 'rubyXL/convenience_methods'
get_rbs 'table', 'parser', 'shortcut_parser', 'comment_parser', 'main_module',
        from: 'program_files'

TEST_FILES = {
  txt: './tests/test.txt',
  pas: './tests/test.pas',
  xlsx: './tests/test.xlsx'
}.freeze

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
    when '.xlsx' then Parser.parse_to_xlsx(*args, to: options.to)
    when 'txt'   then Parser.parse_to_txt(*args,  to: options.to)
    else
      raise(ArgumentError, "'--to' is not XLSX or TXT, it's #{File.extname(options.to)}")
    end
  end
end

command :shortparse do |c|
  c.syntax = './main.rb shortparse FILE'
  c.summary = 'Parses files to get tables with shortcuts'
  c.description = "'Class-Name-Meaning-Type-Structure-Diapazone-Format'"\
  ' tables are parced when given as: c name:t[diapazone](s)"format"'
  c.option '--to FILE', String, 'Print table to FILE'
  c.action do |args, options|
    options.to.nil? && raise(ArgumentError, '--to not specified')
    file = args[0]
    if file.nil?
      file = './tests/test.py'
      puts "File not specified, running test file #{file}"
      sleep 1
    end
    workbook = RubyXL::Workbook.new
    table = Table.new
    sheet = workbook[0]

    Parser.parse_comments(file).each do |line|
      table.add(Parser.shortcut_parse(line))
    end
    puts table
    Parser.table_to_sheet(table, sheet)
    workbook.write(options.to)
  end
end
