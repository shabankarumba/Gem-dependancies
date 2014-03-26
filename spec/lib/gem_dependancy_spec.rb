require 'spec_helper'
require './lib/gem_dependancy'

describe GemDependancy do

  let(:gem_data) do
    [ {"name"=>"activerecord", "downloads"=>30367907, "version"=>"4.0.4",
    "dependencies"=>{"development"=>[], "runtime"=>[{"name"=>"activemodel", 
      "requirements"=> "= 4.0.4"}]} }]
  end

  subject do
   GemDependancy.new("activerecord")
  end
  
  describe "#retrieve_dependancies" do
    it "retrieves the gems dependancies" do
      subject.gem_name.should == "activerecord"
    end
  end

  describe "#retrieve_gem_dependancies" do

    it "returns the gem if it exists" do
      response = double("Response", body: '[ {"name"=>"activerecord", "downloads"=>30367907, "version"=>"4.0.4"}]' )
      HTTParty.should_receive(:get).and_return(response)
      subject.retrieve_gem_dependancies
    end

    it "returns an error if  the gem does not exist" do
      subject.gem_name = "activerecordrrr"
      subject.stub(retrieve_gem_dependancies: "The gem your are trying to find dependencies for does not exist" )
      subject.retrieve_gem_dependancies.should == "The gem your are trying to find dependencies for does not exist"
    end
  end

  describe "#retrieve_runtime_dependancies"  do
    before do
      subject.gem_json = gem_data
    end

    it "returns the runtime dependancies " do
      subject.retrieve_runtime_dependancies
      subject.runtime_dependancy.should == [ "activemodel" ]
    end
  end
end