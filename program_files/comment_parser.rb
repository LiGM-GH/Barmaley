# frozen_string_literal: true

require_relative 'parser'
module CommentParser
  def parse_comments(file, comment_delimiters: nil)
    File.exist?(file) || raise(ArgumentError, "File not found: #{file}")
    %w[.pas .py .rb].include?(File.extname(file)) ||
      raise(ArgumentError, "Extname not supported: #{File.extname(file)}")
    comment_delimiters.nil? &&
      comment_delimiters = comment_delimiters_for(File.extname(file))
    File.open(file, 'r') do |f|
      comments_array(f.read, comment_delimiters)
    end
  end

  def comment_delimiters_for(extname)
    case extname
    when '.pas'         then ['//', "\n"]
    when '.py' || '.rb' then ['#',  "\n"]
    else raise(ArgumentError, "Unknown extension: #{extname}")
    end
  end

  def comments_array(string, comment_delimiters)
    descr_regex = Regexp.compile(
      "#{comment_delimiters[0]}[^#{comment_delimiters.join('')}]*"\
      "#{comment_delimiters[1]}"
    )
    string.scan(descr_regex).map do |elem|
      elem.delete_prefix!(comment_delimiters[0])
      elem.delete_suffix!(comment_delimiters[1])
      elem.strip!
      elem
    end
  end
end
Parser.extend CommentParser
