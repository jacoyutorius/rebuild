require "rspec"
require "./lib/rebuild"

describe "Rebuild" do 

	before do 
		@core = Rebuild::FM.new
	end

	it "should create database?" do 
		system("rm ./anemone.db")
		@core.fetch
		expect(File.exists?("./anemone.db")).to eq true
	end

	it "cant get new epicode?" do 
		expect(Rebuild::DB::Episode.count).to be > 0
	end

	it "cant get episode's shownotes?" do 
		expect(Rebuild::DB::Episode.count).to be > 0
	end

end