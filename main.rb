#!/usr/bin/env ruby
require_relative 'get_rbs'
require 'commander/import'
require 'rubyXL'
require 'rubyXL/convenience_methods'
get_rbs 'table', 'parser', from: 'program_files'

TEST_FILES = {
  txt:  './tests/test.txt',
  pas:  './tests/test.pas',
  xlsx: './tests/test.xlsx',
}

##
# CLI
program :name, "Barmaley"
program :version, "1.0.0"
program :description, "Table maker for labs"

# Let me play a while! 
command :hello do |c|
  c.syntax = "./main.rb hello SOMEONE"
  c.summary = 'Says hello to SOMEONE'
  c.description = "Says hello to SOMEONE"
  c.option '--from SOMEBODY', String, 'Say hello to SOMEONE from SOMEBODY'
  c.action do |args, options|
    options.default :from => nil
    if args.any?
      print "Hello"
      unless options.from.nil?
        print " from #{options.from}"
      end
      print ", #{args.join(", ")}"
    else
      print "Hello to who?"
    end
    puts
  end
end

command :parse do |c|
  c.syntax = "./main.rb parse FILE"
  c.summary = 'Finds tables in FILE'
  c.description = "Finds tables like
  hello: world
  begin: coding
  do: end"
  c.option '--to FILE', String, 'Print table to FILE'
  c.option '--as TYPE', String, 'Print table in format "TXT" or "XLSX"(default)'
  c.action do |args, options|
    options.default to: nil, as: nil
    options.to.nil? && raise(ArgumentError, "'--to' empty. What file should I write to? ")
    File.extname(options.to) == ".xlsx" || raise(ArgumentError, "'--to' is not XLSX, it's #{File.extname(options.to)}")
    options.as ||= "XLSX"
    args.each do |arg|
      if File.exist?(arg)
        workbook = RubyXL::Workbook.new
        sheet = workbook.worksheets[0]
        puts a = Table.new(Parser.new(arg).hashes)
        a.lines.each_with_index do |line, i|
          line.values.each_with_index do |value, j|
            sheet.add_cell(i, j, value)
          end
        end
        workbook.write(options.to)
      else raise(ArgumentError, "File #{arg} does not exist")
      end
    end
  end
end
