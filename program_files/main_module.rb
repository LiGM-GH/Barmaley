# frozen_string_literal: true

require_relative 'parser'
##
# MainModule implements working with XLSX and TXT tables
module MainModule
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
end
Parser.extend(MainModule)
