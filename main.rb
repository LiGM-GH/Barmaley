#!/usr/bin/env ruby
require_relative 'get_rbs'
require 'rubyXL'
require 'rubyXL/convenience_methods'
get_rbs 'table', 'parser', from: 'program_files'

TEST_FILES = {
  txt:  './tests/test.txt',
  pas:  './tests/test.pas',
  xlsx: './tests/test.xlsx',
}
