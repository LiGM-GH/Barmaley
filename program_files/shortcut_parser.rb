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
    name_pos = 2
    descr_regex = /[iom] [a-zA-Z0-9_]+:\ *[bifcsamv]\[[\d\-]+\]\([svamp]\)".*":.+/
    map = string.scan(descr_regex).map do |el|
      hash = {}
      hash[:class] = CLASS_SHORTCUTS[el[0].to_sym]
      hash[:name]  = el[
        name_pos,
        el.index(':') - name_pos
      ]
      hash[:type] = TYPE_SHORTCUTS[
        el[el.index('[') - 1].to_sym
      ]
      hash[:structure] = STRUCTURE_SHORTCUTS[
        el[
          el.index('(') + 1,
          el.index(')') - el.index('(') - 1
        ].to_sym
      ]
      hash[:diapazone] = el[
        el.index('[') + 1,
        el.index(']') - el.index('[') - 1
      ]
      hash[:format] = el[
        el.index('"') + 1,
        el.index('"', el.index('"') + 1) - el.index('"') - 1
      ]
      hash[:meaning] = el[
        el.index(':', el.index(':') + 1) + 2, 
        el.length - 1
      ].strip
      hash
    end
    map.empty? && puts("Retry writing this: #{string}, form it like #{descr_regex}")
    map
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
