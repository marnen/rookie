require File.dirname(__FILE__) + '/spec_helper'
require 'wikitext'

class String
  # Make a string matcher into a more forgiving regex matcher.
  # TODO: use Hpricot or Nokogiri instead of bastardizing HTML like this. :)
  def forgiving
    %r{#{self.gsub(%r[\s{2,}|(\s*\n\s*)]m, '\s*')}}m
  end
end

describe WikitextParser do
  it 'should be a valid class' do
    WikitextParser.class.should == Class
  end
  
  describe '(formatting specs)' do
    before(:each) do
      @parser = WikitextParser.new
    end
    
    describe 'plain text' do
      # TODO: Support MediaWiki's limited set of HTML tags.
      it "should escape HTML" do
        @parser.parse('plain text').to_s.should == '<p>plain text</p>'
        @parser.parse('<ht&ml>').to_s.should == '<p>&lt;ht&amp;ml&gt;</p>'
      end
      
      it "should preserve newlines" do
        newline = "new\nline"
        @parser.parse(newline).to_s.should == "<p>#{newline}</p>"
      end
    end
    
    describe 'bold text' do
      it "should recognize 3 apostrophes for bold" do
        @parser.parse(%q{'''bold'''}).to_s.should == '<p><b>bold</b></p>'
        @parser.parse(%q{Some '''bold''' text.}).to_s.should == '<p>Some <b>bold</b> text.</p>'
      end
    end
    
    describe 'italic text' do
      it "should recognize 2 apostrophes for italics" do
        @parser.parse(%q{''italics''}).to_s.should == '<p><i>italics</i></p>'
      end
    end
    
    describe 'bold italic text' do
      it "should recognize arbitrarily nested bold and italics" do
        @parser.parse(%q{'''''bold italics'''''}).to_s.should =~ %r{^<p><([bi])><([bi])>bold italics</\2></\1></p>$}
        @parser.parse(%q{'''bold with ''italics'' in the middle'''}).to_s.should == '<p><b>bold with <i>italics</i> in the middle</b></p>'
        @parser.parse(%q{''italics with '''bold''' in the middle''}).to_s.should == '<p><i>italics with <b>bold</b> in the middle</i></p>'
      end
    end
    
    describe 'paragraph breaks' do
      it "should start a new paragraph on a double newline" do
        @parser.parse("a\n\nb").to_s.should =~ %r{<p>a</p>\s*<p>b</p>}m
      end
      
      it "should not start a new paragraph on a single newline" do
        @parser.parse("a\nb").to_s.should_not =~ %r{a.*</p>.*b}
      end
    end
    
    describe 'headings' do
      it "should recognize equals signs for headings" do
        @parser.parse(<<IN).to_s.should == <<OUT
= Heading 1 =
paragraph 1
== Heading 2 ==
paragraph 2
IN
<h1>Heading 1</h1>
<p>paragraph 1</p>
<h2>Heading 2</h2>
<p>paragraph 2</p>
OUT
      end
    end
    
    describe 'lists' do
      describe 'bulleted' do
        it "should understand bulleted lists" do
          @parser.parse(<<IN).to_s.should =~ <<OUT.forgiving
* One
* Two
* Three
IN
<ul>
  <li>
    One
  </li>
  <li>
    Two
  </li>
  <li>
    Three
  </li>
</ul>
OUT
        end
        
        it "should understand nested bulleted lists" do
          @parser.parse(<<IN).to_s.should =~ <<OUT.forgiving
* Alpha
* Beta
** Beta 1
* Gamma
IN
<ul>
  <li>
    Alpha
  </li>
  <li>
    Beta
    <ul>
      <li>
        Beta 1
      </li>
    </ul>
  </li>
  <li>
    Gamma
  </li>
</ul>
OUT
        end
      end
      
      describe 'numbered' do
        it "should understand numbered lists" do
          @parser.parse(<<IN).to_s.should =~ <<OUT.forgiving
# One
# Two
# Three
IN
<ol>
  <li>
    One
  </li>
  <li>
    Two
  </li>
  <li>
    Three
  </li>
</ol>
OUT
        end

        it "should understand nested numbered lists" do
          @parser.parse(<<IN).to_s.should =~ <<OUT.forgiving
# Alpha
# Beta
## Beta 1
# Gamma
IN
<ol>
  <li>
    Alpha
  </li>
  <li>
    Beta
    <ol>
      <li>
        Beta 1
      </li>
    </ol>
  </li>
  <li>
    Gamma
  </li>
</ol>
OUT
        end
      end
    end
  end
end
