require File.dirname(__FILE__) + '/spec_helper'
require 'rookie'

describe Rookie do
  it 'should be a valid class' do
    Rookie.class.should == Class
  end
  
  describe '(constructor)' do
    it 'should be valid with 1 String argument' do
      Rookie.should respond_to(:new)
      lambda{Rookie.new('a string')}.should_not raise_error
    end
  end
  
  describe 'to_s' do
    it 'should return plain strings just the way they were' do
      string = 'This is a string.'
      Rookie.new(string).to_s.should == string
    end
    
    it 'should return the parsed version of any string with markup' do
      Rookie.new(%q{Here's some '''bold''' text.}).to_s.should == %q{Here's some <b>bold</b> text.}
    end
  end
end
