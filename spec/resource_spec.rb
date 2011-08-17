require "spec_helper"

describe Resource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = Resource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

  context "Prerequisites" do

    it "should return an ordered list of prerequisites all of the same type" do
      top_level_resource = FileResource.new(nil, :top_level, [])
      next_level_resource = FileResource.new(nil, :next_level_resource, [ top_level_resource ])
      next_level_resource_1 = Resource.new(nil, :next_level_resource_1, [ top_level_resource ])
      next_level_resource_2 = FileResource.new(nil, :next_level_resource_2, [ next_level_resource ])
      bottom_level_resource = Resource.new(nil, :bottom_level_resource, [ next_level_resource, next_level_resource_2 ])
      
      bottom_level_resource.ordered_prerequisites(FileResource).should == [ top_level_resource, next_level_resource, next_level_resource_2 ]
    end

    it "should return an empty list if no matching resources are found" do
      top_level_resource = FileResource.new(nil, :top_level, [])
      next_level_resource = FileResource.new(nil, :next_level_resource, [ top_level_resource ])
      next_level_resource_1 = Resource.new(nil, :next_level_resource_1, [ top_level_resource ])
      next_level_resource_2 = FileResource.new(nil, :next_level_resource_2, [ next_level_resource ])
      bottom_level_resource = Resource.new(nil, :bottom_level_resource, [ next_level_resource, next_level_resource_2 ])
      
      bottom_level_resource.ordered_prerequisites(DirectoryResource).should == [ ]
    end

  end

end
