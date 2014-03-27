require 'spec_helper'
require './lib/gem_dependancy'

describe GemDependancy do

  let(:gem_data) do
    [ {"name"=>"activerecord", "downloads"=>30367907, "version"=>"4.0.4",
    "dependencies"=>{"development"=>[], "runtime"=>[{"name"=>"activemodel", 
      "requirements"=> "= 4.0.4"}]} }]
  end

  describe "#retrieve_gem_dependancies success" do
    it "returns the gem if it exists" do
      response = double("Response", body: '[ {"name"=>"activerecord", "downloads"=>30367907, "version"=>"4.0.4"}]' )
      HTTParty.should_receive(:get).and_return(response)
      subject.retrieve_gem_dependancies("activerecord")
    end
  end

  describe "#retrieve_gem_dependancies failure" do
    it "returns an error if  the gem does not exist" do
      subject.stub(retrieve_gem_dependancies: "The gem your are trying to find dependencies for does not exist" )
      subject.retrieve_gem_dependancies("activerecordrrr").should == "The gem your are trying to find dependencies for does not exist"
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

  describe "#retrieves_dependancies" do
    before do
      subject.runtime_dependancy = ["activemodel"]
    end

    it "retrieves the dependancies" do
      subject.stub(retrive_dependancies: "Ruby Gem name:- activemodel \n
                        Runtime dependancy:- activemodel \n
                        Runtime dependancy:- activesupport \n
                        Runtime dependancy:- builder\n ")
      subject.retrive_dependancies.should eq "Ruby Gem name:- activemodel \n
                        Runtime dependancy:- activemodel \n
                        Runtime dependancy:- activesupport \n
                        Runtime dependancy:- builder\n "
    end
  end

  describe "#output_dependancies" do
    before do
      subject.runtime_dependancy = ["activemodel", "two"]
    end

    it "outputs the name of the dependancy" do
      subject.should_receive(:puts).with("Runtime dependancy:- activemodel")
      subject.should_receive(:puts).with("Runtime dependancy:- two")
      subject.output_dependancies
    end
  end
end