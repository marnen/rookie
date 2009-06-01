require File.dirname(__FILE__) + '/spec_helper'
require 'erb'
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
    
    it "should recognize 3 apostrophes for bold" do
      @parser.parse(%q{'''bold'''}).should_not be_nil
      @parser.parse(%q{Some '''bold''' text.}).should_not be_nil
    end
  end
end
