require 'spec_helper'

describe ComponentsController, :type => :controller do

  it "should return first level components" do
    get :index, :id => "ARC-0037"
    expect(response).to be_success
  end

  it "should return first-level components with a start and row count" do
    get :index, :id => "ARC-0037", :start => 50, :rows => 25
    expect(response).to be_success
  end

  it "should return additional components from a given parent" do
    get :index, :id => "ARC-0037", :ref => "ref10"
    expect(response).to be_success
  end

  it "should return additional components from a given parent with a start and row count" do
    get :index, :id => "ARC-0037", :ref => "ref10", :start => 50, :rows => 25
    expect(response).to be_success
  end

  it "should not change the current search session" do
    get :index, :id => "ARC-0037", :ref => "ref10", :start => 50, :rows => 25
    expect {controller.send(:current_search_session)}.to raise_error(NoMethodError)
  end

end
