require_relative 'get_rbs'

task :parser do
  get_rbs 'parser', from: 'program_files'
end

task :table do
  get_rbs 'table',  from: 'program_files'
end

task :test_parser => :parser do
  puts Parser.new("#{__dir__}/tests/test.txt").get_hashes
end

task :test_table => :table do
  puts Table.new({'Book':   'Parrot Crown', 
                  'Descr':  'A humorous parrot', 
                  'Author': 'Alexandro Volta'    }, 
                  {k: 3})
end

task :get_table_from => [:table, :parser] do
  table = Table.new()
  Parser.new(ARGV[1]).hashes.each do |line|
    table.add(line)
  end
  puts table
end

task :main do
  get_rbs 'main'
end
