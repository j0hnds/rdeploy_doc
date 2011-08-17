require "spec_helper"

describe DirectoryResource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = DirectoryResource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

end
