# frozen_string_literal: true

# Copyright (c) 2006-2007 Justin French
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class String
  ##
  # Escape string
  #
  # "gucci bag"      => "gucci+bag"
  # "gucci bag +red" => "gucci+bag+%2Bred"

  def escape
    Rack::Utils.escape(self)
  end

  ##
  # Unescape string
  #
  # "gucci+bag"        => "gucci bag"
  # "gucci+bag+%2Bred" => "gucci bag +red"

  def unescape
    Rack::Utils.unescape(self)
  end

  ##
  # Record Indentifier
  #
  # Clothing-Accessories-120000       => "120000"
  # LV-louis-vuitton-bag-143370499    => "143370499"
  # LV-vuitton-bag-143370499+bogus    => "143370499"
  # kwaliteits-bruine-Gucci-uh2zp9uhl => "uh2zp9uhl"

  def numeric_id(sep = '-')
    mb_chars.split(sep).last.to_s =~ /(\w+)/ && Regexp.last_match[1]
  end

  def stringify
    gsub(/[^a-z\s_]/i, ' ').gsub(/\s{2,}/, ' ').gsub('+', ' ')
  end

  def convert_to_s
    to_s =~ /(\w*[^\d-])/ && Regexp.last_match[1]
  end

  def convert_to_array
    split(',').map(&:strip)
  end

  def numeric?
    return true if self =~ /^\d+$/

    begin
      true if Float(self)
    rescue StandardError
      false
    end
  end

  def to_bool
    return true if self =~ /^(true|t|yes|y|1)$/i
    return false if empty? || self =~ /^(false|f|no|n|0)$/i

    raise ArgumentError, "invalid value: #{self}"
  end
  ##
  # Override ActiveSupport::CoreExtensions::String#parameterize to fix a bug
  # with multi-byte characters
  #
  # Before fix:
  #
  # >> "Apple iPod classic 6th Generation Black (160 GB) MP3\241\255".parameterize
  # NoMethodError: undefined method `normalize' ....

  # def parameterize(sep = "-")
  #   replace(ActiveSupport::Multibyte::Chars.tidy_bytes(self))
  #   ActiveSupport::Inflector.parameterize(self, sep)
  # end

  ##
  # Slugize
  #
  # Similar to #parameterize but less strict.. ie will not remove non-ascii characters

  def sanitize_description(options = {})
    ActionController::Base.helpers.sanitize(gsub('<h1', '<h3').gsub('h1>', 'h3>'), { tags: ActionView::Base.sanitized_allowed_tags.to_a + %w[tr td th table span tbody colgroup col] - %w[a img], attributes: ActionView::Base.sanitized_allowed_attributes.to_a + %w[style cellspacing cellpadding border] }.merge(options)).gsub(/ {2,}/, ' ').gsub(/(\<br\>){2,}/, '<br>')
  end

  def slugize(options = {})
    options.reverse_merge!(seperator: '-', downcase: true)

    _sep = options.delete(:seperator)

    _string = mb_chars.split.join(_sep)
                      .mb_chars.gsub(%r{(\.|\$|\&|\+|\,|/|\:|\;|\=|\?|\@|\<|\>|\#|\%|\{|\}|\||\\|\^|\[|\]|\`|\'|\")}, _sep)
                      .mb_chars.gsub(/#{_sep}{1,}/, _sep)
                      .mb_chars.gsub(/^#{_sep}/, '')
                      .mb_chars.gsub(/#{_sep}$/, '')

    options[:downcase] ? _string.downcase : _string
  end

  def d2
    format('%02d', self)
  end

  def strip_emoji!
    regexp = /[\u{00A9}\u{00AE}\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}-\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}-\u{2623}\u{2626}\u{262A}\u{262E}-\u{262F}\u{2638}-\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2692}-\u{2694}\u{2696}-\u{2697}\u{2699}\u{269B}-\u{269C}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26B0}-\u{26B1}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26C8}\u{26CE}-\u{26CF}\u{26D1}\u{26D3}-\u{26D4}\u{26E9}-\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}-\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F321}\u{1F324}-\u{1F393}\u{1F396}-\u{1F397}\u{1F399}-\u{1F39B}\u{1F39E}-\u{1F3F0}\u{1F3F3}-\u{1F3F5}\u{1F3F7}-\u{1F4FD}\u{1F4FF}-\u{1F53D}\u{1F549}-\u{1F54E}\u{1F550}-\u{1F567}\u{1F56F}-\u{1F570}\u{1F573}-\u{1F579}\u{1F587}\u{1F58A}-\u{1F58D}\u{1F590}\u{1F595}-\u{1F596}\u{1F5A5}\u{1F5A8}\u{1F5B1}-\u{1F5B2}\u{1F5BC}\u{1F5C2}-\u{1F5C4}\u{1F5D1}-\u{1F5D3}\u{1F5DC}-\u{1F5DE}\u{1F5E1}\u{1F5E3}\u{1F5EF}\u{1F5F3}\u{1F5FA}-\u{1F64F}\u{1F680}-\u{1F6C5}\u{1F6CB}-\u{1F6D0}\u{1F6E0}-\u{1F6E5}\u{1F6E9}\u{1F6EB}-\u{1F6EC}\u{1F6F0}\u{1F6F3}\u{1F910}-\u{1F918}\u{1F980}-\u{1F984}\u{1F9C0}]/
    gsub regexp, ''
  end

  ##
  # HTML unescape
  #
  # Pretty much the opposite of html_escape

  def html_unescape
    gsub('&amp;', '&').gsub('&quot;', '"').gsub('&gt;', '>').gsub('&lt;', '<').gsub('&nbsp;', ' ')
  end

  # Capitalizes only the first character of a string (unlike "string".capitalize), leaving the rest
  # untouched.  spinach => Spinach, CD => CD, cat => Cat, crAzY => CrAzY
  def capitalize_first
    string = self[0, 1].capitalize + self[1, length].to_s
    string
  end

  # Capitalizes the first character of all words not found in words_to_skip_capitalization_of()
  # Examples of skipped words include 'of', 'the', 'or', etc.  Also capitalizes the first character
  # of the string regardless.
  def capitalize_most_words
    split.collect { |w| words_to_skip_capitalization_of.include?(w.downcase) ? w : w.capitalize_first }.join(' ').capitalize_first
  end

  # Capitalizes the first character of all words in string
  def capitalize_words
    split.collect(&:capitalize_first).join(' ')
  end

  # If a string is longer than 'length', returns the string shortened to length, with 'suffix'
  # appended.  Otherwise, returns the string untouched.  Default suffix of '&#8230;' (three horizontal
  # elipses) is provided.
  def shorten(length, suffix = '&#8230;')
    if self.length > length - 1
      slice(0..length - 1) + suffix
    else
      self
    end
  end

  def custom_titlecase
    # before \b\w
    gsub(/\b[^'s\s|^'t\s]/, &:upcase)
  end

  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process
  # (partially lifted from Typo (MIT licensed))
  def slugorize
    result = downcase
    result.gsub!(/&(\d)+;/, '') # Ditch Entities
    result.gsub!('&', 'and')    # Replace & with 'and'
    result.gsub!(/['"]/, '')    # replace quotes by nothing
    result.gsub!(/\W/, ' ')     # strip all non word chars
    result.gsub!(/\ +/, '-')    # replace all white space sections with a dash
    result.gsub!(/(-)$/, '')    # trim dashes
    result.gsub!(/^(-)/, '')    # trim dashes
    result
  end

  def snake_case
    result = downcase
    result.gsub!(/&(\d)+;/, '') # Ditch Entities
    result.gsub!('&', 'and')    # Replace & with 'and'
    result.gsub!('-', '_') # Replace - with '_'
    result.gsub!(/['"]/, '')    # replace quotes by nothing
    result.gsub!(/\W/, ' ')     # strip all non word chars
    result.gsub!(/\ +/, '_')    # replace all white space sections with a dash
    result.gsub!(/(_)$/, '')    # trim dashes
    result.gsub!(/^(_)/, '')    # trim dashes
    result
  end

  def normalized_phrase
    result = downcase
    result.gsub!('&', ' and ') # Replace & with 'and'
    result.gsub!('_', ' ') # Replace _ with ''
    result.gsub!('-', ' ') # remove dashes
    result.gsub!(/\ +/, ' ') # trim empty spaces
    result.strip!
    result
  end

  def canonicalize
    gsub(%r{(/page/\d+|\?.*|\&.*)}, '')
  end

  def deparameterize
    split('-').join(' ').humanize.titleize
  end

  # Returns +text+ wrapped at +len+ columns and indented +indent+ spaces.
  #
  # === Examples
  #
  #   my_text = "Here is a sample text. with more than 40 characters"
  #
  #   format_paragraph(my_text, 25, 4)
  #   # => "    Here is a sample text with\n    more than 40 characters"
  def format_paragraph(len = 72, indent = 2)
    sentences = [[]]

    split.each do |word|
      if (sentences.last + [word]).join(' ').length > len
        sentences << [word]
      else
        sentences.last << word
      end
    end

    sentences.map do |sentence|
      "#{' ' * indent}#{sentence.join(' ')}"
    end.join "\n"
  end

  def tidy_bytes(force = false)
    chars(Unicode.tidy_bytes(@wrapped_string, force))
  end

  def dedupe
    split(' ').uniq.join(' ')
  end

  # HACK: to localize content for different regions
  # not the best options but since the content is cached
  # this option is ok for now.
  # TODO remove domain check from this method; the string should not need to check
  # type of domain to make the modifications
  def localize(domain)
    return self unless AppConstants::COUNTRY_TOP_LEVEL_DOMAINS.include?(domain)

    content = gsub('rebelsmarket.com', domain)
    content
  end

  # adding colors
  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  private

  # Defines an array of words to which capitalize_most_words() should skip over.
  # TODO: Should "it" be included in the list?
  def words_to_skip_capitalization_of
    %w[of a the and an or nor but if then else when up at from by on off for in out over to]
  end
end
