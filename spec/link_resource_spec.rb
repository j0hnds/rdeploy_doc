require "spec_helper"

describe LinkResource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = LinkResource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

  context "Formatted Output" do
    
    before(:each) do
      @lr = LinkResource.new('The description', :name, [ :pre1, :pre2 ])
    end

    it "should display the file resource information in the form of a Posix long file listing" do
      @lr.path = 'file.txt'
      @lr.owner = 'root'
      @lr.group = 'developers'
      @lr.target = 'file-1.2.3.txt'

      @lr.to_posix.should == 'lrwxrwxrwx root       developers file.txt -> file-1.2.3.txt'
    end

    it "should raise an exception if the target is not specified on the link" do
      @lr.path = 'file.txt'
      @lr.owner = 'root'
      @lr.group = 'developers'

      lambda { @lr.to_posix }.should raise_error
    end

  end

end
