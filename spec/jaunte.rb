require 'moneta'
require 'moneta/memory'
require "#{File.dirname(__FILE__)}/../lib/jaunte"

describe Jaunte do
  before(:each) do
    @jaunte = Jaunte.new(:store => Moneta::Memory.new)
  end
  
  it "should be able to append new values" do
    pending
  end
  
  it "should weigh new values properly" do
    pending
  end
  
  it "should tag predictably" do
    pending
  end
  
  it "should return a list of tuples when asked for stat" do
    pending
  end
  
  it "should return a proper path when asked to jump" do
    pending
  end
end