require File.dirname(__FILE__) + '/spec_helper'
require 'rookie'

describe Rookie do
  it 'should be a valid class' do
    Rookie.class.should == Class
  end
end
