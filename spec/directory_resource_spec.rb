require "spec_helper"

describe DirectoryResource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = DirectoryResource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

  context "Formatted Output" do
    
    before(:each) do
      @fr = DirectoryResource.new('The description', :name, [ :pre1, :pre2 ])
    end

    it "should display the directory resource information in the form of a Posix long file listing" do
      @fr.path = 'file.txt'
      @fr.mode = 02775
      @fr.owner = 'root'
      @fr.group = 'developers'

      @fr.to_posix.should == 'drwxrwsr-x root       developers file.txt'
    end

  end

end
