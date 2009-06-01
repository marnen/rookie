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
  end
end
