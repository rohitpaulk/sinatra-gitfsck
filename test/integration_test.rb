require File.expand_path('../helper', __FILE__)
require File.expand_path('../integration_helper', __FILE__)

class IntegrationTest < Test::Unit::TestCase
  extend IntegrationHelper
  attr_accessor :server

  it('sets the app_file') { assert_equal server.app_file, server.get("/app_file") }
  it('only extends main') { assert_equal "true", server.get("/mainonly") }

  it 'logs once in development mode' do
    random = "%064x" % Kernel.rand(2**256-1)
    server.get "/ping?x=#{random}"
    assert_equal 1, server.log.scan("GET /ping?x=#{random}").count
  end

  it 'starts the correct server' do
    exp = %r{
      ==\sSinatra/#{Sinatra::VERSION}\s
      has\staken\sthe\sstage\son\s\d+\sfor\sdevelopment\s
      with\sbackup\sfrom\s#{server}
    }ix

    assert_match exp, server.log
  end
end