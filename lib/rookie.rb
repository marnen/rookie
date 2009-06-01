require 'treetop'
=begin rdoc
Wrapper for MediaWiki parser.

Usage:
 Rookie.new('string').to_s # => 'string'
 Rookie.new("Here's some '''bold''' text.").to_s # => "Here's some <b>bold</b> text."
=end
class Rookie
  def initialize(string)
    @string = string
  end
  
  # Returns a parsed representation of the input string.
  def to_s
    @string
  end
end
