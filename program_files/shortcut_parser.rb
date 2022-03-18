# frozen_string_literal: true

require_relative 'parser'
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
module ShortcutParser
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
    'i': 'Входные данные',            # 'input data',
    'o': 'Выходные данные',           # 'output data',
    'm': 'Промежуточные данные'       # 'intermediate data'
  }.freeze

  STRUCTURE_SHORTCUTS = {
    's': 'Простая переменная',        # 'simple variable',
    'a': 'Массив',                    # 'array',
    'm': 'Матрица',                   # 'matrix',
    'p': 'Указатель',                 # 'pointer'
    'v': 'Сложная структура'          # 'complex variable'
  }.freeze

  def shortcut_parse(string)
    map = string.scan(descr_regex).map do |el|
      %i[class name type structure diapazone format meaning].map do |data|
        [data, send("parse_#{data}", el)]
      end.to_h
    end
    if map.empty?
      puts("Retry writing \"#{string}\", "\
            "form it like #{descr_regex}")
    end
    map
  end

  def descr_regex
    @descr_regex ||= Regexp.compile(
      "[#{CLASS_SHORTCUTS.keys.join}] [a-zA-Z0-9_]+:\\ *"\
      "[#{TYPE_SHORTCUTS.keys.join}]\\[[\\d\-]+\\]\\("\
      "[#{STRUCTURE_SHORTCUTS.keys.join}]\\)\".*\":.+"
    )
  end

  def parse_class(el)
    CLASS_SHORTCUTS[el[0].to_sym]
  end

  def parse_name(str)
    name_pos = 2
    str[name_pos, str.index(':') - name_pos]
  end

  def parse_type(str)
    TYPE_SHORTCUTS[
      str[str.index('[') - 1].to_sym
    ]
  end

  def parse_structure(str)
    STRUCTURE_SHORTCUTS[
        str[
        str.index('(') + 1,
        str.index(')') - str.index('(') - 1
      ].to_sym
    ]
  end

  def parse_diapazone(str)
    str[
      str.index('[') + 1,
      str.index(']') - str.index('[') - 1
    ]
  end

  def parse_format(str)
    str[
      str.index('"') + 1,
      str.index('"', str.index('"') + 1) - str.index('"') - 1
    ]
  end

  def parse_meaning(str)
    str[
      str.index(':', str.index(':') + 1) + 2,
      str.length - 1
    ].strip
  end

  def name(string)
    string[string.index(' ') + 1, string.index(':') - string.index(' ') - 1]
  end

  def self.to_method_name(const)
    "short_#{const.to_s.delete_suffix('_SHORTCUTS').downcase}"
  end

  constants.select { |c| c =~ /_*_SHORTCUTS/ }.each do |const|
    # puts "#{const.to_s.ljust(constants.max_by(&:length).length)} = #{constant = const_get(const)}"
    constant = const_get(const)
    # p instance_methods
    define_method(to_method_name(const)) do |char|
      if constant.keys.include?(char.to_sym)
        constant[char.to_sym]
      else
        false
      end
    end
  end
end

Parser.extend(ShortcutParser)
