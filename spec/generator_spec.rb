require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Namey::Generator" do
  before(:each) do
    @uri = "#{'jdbc:' if RUBY_PLATFORM == 'java'}#{Namey.db_path}"
    @gen = Namey::Generator.new(@uri)
  end

  describe "incoming sequel object" do
    it "should work" do
      @tmp = Sequel.connect(@uri)
      @gen2 = Namey::Generator.new(@tmp)
    end
  end
  
  describe "name" do
    it "should pass params to generate" do
      @gen.should_receive(:generate).with(:frequency => :common, :with_surname => true)
      @gen.name
    end
  end

  describe "male" do
    it "should pass params to generate" do
      @gen.should_receive(:generate).with(:type => :male, :frequency => :common, :with_surname => true)
      @gen.male
    end
  end

  describe "female" do
    it "should pass params to generate" do
      @gen.should_receive(:generate).with(:type => :female, :frequency => :common, :with_surname => true)
      @gen.female
    end
  end

  describe "surname" do
    it "should pass params to generate" do
      @gen.should_receive(:generate).with(:type => :surname, :frequency => :common)
      @gen.surname
    end
  end

  describe "generate" do
    it "should pass to get_name once for surnames" do
      @gen.should_receive(:get_name).with(:surname, 0, 20).and_return("Chuck")
      @gen.generate(:type => :surname).should == "Chuck"
    end

    it "should pass to get_name once when with_surname is false" do
      @gen.should_receive(:get_name).with(:male, 0, 20).and_return("Chuck")
      @gen.generate(:type => :male, :with_surname => false).should == "Chuck"
    end

    it "should pass to get_name twice for full names" do
      @gen.should_receive(:get_name).with(:male, 0, 20).and_return("Chuck")      
      @gen.should_receive(:get_name).with(:surname, 0, 20).and_return("Smith")
      @gen.generate(:type => :male).should == "Chuck Smith"
    end

    it "should work" do
      @gen.generate.should_not be_nil
    end

    it "should work even for bad frequencies" do
      @gen.generate(:frequency => :foo).should_not be_nil
      @gen.generate(:min_freq => 50, :max_freq => 2).should_not be_nil
    end
  end

end
