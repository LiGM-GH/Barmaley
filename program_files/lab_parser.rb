# frozen_string_literal: true

##
# LabParser is needed to get tables like
#   class:      (...),
#   name:       (...),
#   meaning:    (...),
#   type:       (...),
#   structure:  (...),
#   diapazone:  (...),
#   format:     (...)
# written like 'c n:t[d](s)"f": a really long meaning'
class LabParser
  attr_accessor :hash

  TYPE_SHORTCUTS = {
    'b': 'boolean',
    'i': 'integer',
    'f': 'float',
    'c': 'char',
    's': 'string',
    'a': 'array',
    'm': 'matrix',
    'v': 'User-defined class'
  }.freeze

  CLASS_SHORTCUTS = {
    'i': 'input data',
    'o': 'output data',
    'm': 'intermediate data'
  }.freeze

  STRUCTURE_SHORTCUTS = {
    's': 'simple variable',
    'a': 'array',
    'm': 'matrix'
  }.freeze

  class << self
    def shortcut_parse(string)
      @hash = {}
      @hash[:class] = short_class(p(string[0]))
      @hash[:name]  = name(string)
      @hash[:type]  = short_type(string[string.index(':') + 1])
      if short_structure(string[string.index('(') + 1])
        @hash[:structure] = short_structure(
          string[string.index('(') + 1]
        )
      end
      @hash
    end

    def name(string)
      string[string.index(' ') + 1, string.index(':') - string.index(' ') - 1]
    end

    def to_method_name(const)
      "short_#{const.to_s.delete_suffix('_SHORTCUTS').downcase}"
    end
  end

  constants.select { |c| c =~ /_*_SHORTCUTS/ }.each do |const|
    p constant = const_get(const)
    define_singleton_method(to_method_name(const)) do |char|
      if constant.keys.include?(char.to_sym)
        constant[char.to_sym]
      else
        false
      end
    end
  end
end

p LabParser.shortcut_parse('i not_a_really_bad_gateway:i[1-5](s)"f": a really long meaning')
