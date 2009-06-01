require File.dirname(__FILE__) + '/spec_helper'
require 'wikitext'

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
        @parser.parse('plain text').to_s.should == 'plain text'
        @parser.parse('<ht&ml>').to_s.should == '&lt;ht&amp;ml&gt;'
      end
    end
    
    describe 'bold text' do
      it "should recognize 3 apostrophes for bold" do
        @parser.parse(%q{'''bold'''}).to_s.should == '<b>bold</b>'
        @parser.parse(%q{Some '''bold''' text.}).to_s.should == 'Some <b>bold</b> text.'
      end
    end
    
    describe 'italic text' do
      it "should recognize 2 apostrophes for italics" do
        @parser.parse(%q{''italics''}).to_s.should == '<i>italics</i>'
      end
    end
    
    describe 'bold italic text' do
      it "should recognize arbitrarily nested bold and italics" do
        @parser.parse(%q{'''''bold italics'''''}).to_s.should =~ %r{^<([bi])><([bi])>bold italics</\2></\1>$}
        @parser.parse(%q{'''bold with ''italics'' in the middle'''}).to_s.should == '<b>bold with <i>italics</i> in the middle</b>'
        @parser.parse(%q{''italics with '''bold''' in the middle''}).to_s.should == '<i>italics with <b>bold</b> in the middle</i>'
      end
    end
  end
end
