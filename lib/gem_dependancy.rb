require 'httparty'
require 'json'

class GemDependancy
  include HTTParty
  
  attr_accessor :gem_name, :runtime_dependancy, :gem_json

  def initialize(gem_name)
    @gem_name = gem_name
    @runtime_dependancy = []
    @gem_json = ""
  end

  def retrieve_gem_dependancies
    begin
      response = HTTParty.get("http://rubygems.org/api/v1/gems/#{@gem_name}.json")
      @gem_json = JSON.parse(response.body)
    rescue JSON::ParserError
      "The gem your are trying to find dependencies for does not exist"
    end
  end

  def retrieve_runtime_dependancies
    @gem_json[0]["dependencies"]["runtime"].each do |dependencies|
      @runtime_dependancy << dependencies['name']
    end
  end

  def retrive_dependancies
    retrieve_gem_dependancies
  end
end