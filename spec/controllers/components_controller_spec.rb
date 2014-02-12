require 'spec_helper'

describe ComponentsController do

  it "should return first level components" do
    get :index, :id => "ARC-0037"
    response.should be_success
  end

  it "should return first-level components with a start and row count" do
    get :index, :id => "ARC-0037", :start => 50, :rows => 25
    response.should be_success
  end

  it "should return additional components from a given parent" do
    get :index, :id => "ARC-0037", :ref => "ref10"
    response.should be_success
  end

  it "hould return additional components from a given parent with a start and row count" do
    get :index, :id => "ARC-0037", :ref => "ref10", :start => 50, :rows => 25
    response.should be_success
  end

end
