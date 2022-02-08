# frozen_string_literal: true

##
# ShortcutParser is needed to get tables like
#   class:      (...),
#   name:       (...),
#   meaning:    (...),
#   type:       (...),
#   structure:  (...),
#   diapazone:  (...),
#   format:     (...)
# written like 'c n:t[d](s)"f": a really long meaning'
class ShortcutParser
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
      
      name_pos = 2
      descr_regex = /[iom] [a-zA-Z_]+:[bifcsamv]\[[\d\-]+\]\([sam]\)".+":.+/
      string.scan(descr_regex).map do |el|
        hash = {}
        hash[:class] = ShortcutParser::CLASS_SHORTCUTS[el[0].to_sym]
        hash[:name]  = (
          el[name_pos,
             el.index(':') - name_pos]
        )
        hash[:type] = ShortcutParser::TYPE_SHORTCUTS[
          el[el.index(':') + 1,
             el.index('[') - el.index(':') - 1].to_sym
        ]
        hash[:structure] = ShortcutParser::STRUCTURE_SHORTCUTS[
          el[el.index('(') + 1,
             el.index(')') - el.index('(') - 1].to_sym
        ]
        hash[:diapazone] = (
          el[el.index('[') + 1,
             el.index(']') - el.index('[') - 1]
        )
        hash[:format] = (
          el[el.index('"') + 1,
             el.index('"', el.index('"') + 1) - el.index('"') - 1]
        )
        hash[:meaning] = el[el.index(': ') + 2, el.length - 1]
        hash
      end
    end

    def name(string)
      string[string.index(' ') + 1, string.index(':') - string.index(' ') - 1]
    end

    def to_method_name(const)
      "short_#{const.to_s.delete_suffix('_SHORTCUTS').downcase}"
    end
  end

  constants.select { |c| c =~ /_*_SHORTCUTS/ }.each do |const|
    puts "#{const.to_s.ljust(constants.max_by(&:length).length)} = "\
         "#{constant = const_get(const)}"
    define_singleton_method(to_method_name(const)) do |char|
      if constant.keys.include?(char.to_sym)
        constant[char.to_sym]
      else
        false
      end
    end
  end
end
p ShortcutParser.shortcut_parse("i a:i[0-100](s)\"Format\": a really long meaning")
p ShortcutParser.shortcut_parse(
  "o b:f[0-100](s)\"Format\": a really long meaning"
)

