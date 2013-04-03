require 'spec_helper'

describe 'App' do
  it "should respond to GET" do
    get '/test_room'
    last_response.should be_ok
    # last_response.body.should match(/test_room/)
  end
end