require 'httparty'
require 'json'

class GemDependancy
  include HTTParty
  
  attr_accessor :runtime_dependancy, :gem_json

  def initialize
    @runtime_dependancy = []
    @gem_json = ""
  end

  def retrieve_gem_dependancies(gem_name)
    begin
      response = HTTParty.get("http://rubygems.org/api/v1/gems/#{gem_name}.json")
      @gem_json = JSON.parse(response.body)
      puts "Ruby Gem name:- #{gem_name}"
    rescue JSON::ParserError
      "The gem your are trying to find dependencies for does not exist"
    end
  end

  def retrieve_runtime_dependancies
    gem_data = @gem_json.is_a?(Array) ? @gem_json[0] : @gem_json
    gem_data["dependencies"]["runtime"].each do |dependencies|
      @runtime_dependancy << dependencies['name']
    end
  end

  def retrive_dependancies
    @runtime_dependancy.each do |dependency|
      retrieve_gem_dependancies(dependency)
      retrieve_runtime_dependancies
      output_dependancies 
    end
  end

  def output_dependancies
    @runtime_dependancy.each do |name|
      puts "Runtime dependancy:- #{name}" 
    end
  end
end