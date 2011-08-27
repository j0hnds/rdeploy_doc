require "spec_helper"

describe RDeployDoc::Resource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = RDeployDoc::Resource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

  context "Prerequisites" do

    it "should return an ordered list of prerequisites all of the same type" do
      top_level_resource = RDeployDoc::FileResource.new(nil, :top_level, [])
      next_level_resource = RDeployDoc::FileResource.new(nil, :next_level_resource, [ top_level_resource ])
      next_level_resource_1 = RDeployDoc::Resource.new(nil, :next_level_resource_1, [ top_level_resource ])
      next_level_resource_2 = RDeployDoc::FileResource.new(nil, :next_level_resource_2, [ next_level_resource ])
      bottom_level_resource = RDeployDoc::Resource.new(nil, :bottom_level_resource, [ next_level_resource, next_level_resource_2 ])
      
      bottom_level_resource.ordered_prerequisites(RDeployDoc::FileResource).should == [ top_level_resource, next_level_resource, next_level_resource_2 ]
    end

    it "should return an empty list if no matching resources are found" do
      top_level_resource = RDeployDoc::FileResource.new(nil, :top_level, [])
      next_level_resource = RDeployDoc::FileResource.new(nil, :next_level_resource, [ top_level_resource ])
      next_level_resource_1 = RDeployDoc::Resource.new(nil, :next_level_resource_1, [ top_level_resource ])
      next_level_resource_2 = RDeployDoc::FileResource.new(nil, :next_level_resource_2, [ next_level_resource ])
      bottom_level_resource = RDeployDoc::Resource.new(nil, :bottom_level_resource, [ next_level_resource, next_level_resource_2 ])
      
      bottom_level_resource.ordered_prerequisites(RDeployDoc::DirectoryResource).should == [ ]
    end

  end

  context "Resource Children" do
    
    it "tracks the children of resources as they are constructed" do
      top_level_rsrc = RDeployDoc::Resource.new(nil, :top_level, [])
      second_level_rsrc = RDeployDoc::Resource.new(nil, :second_level, [ top_level_rsrc ])

      top_level_rsrc.children.should == [ second_level_rsrc ]
      second_level_rsrc.children.should be_empty
    end

    it "it ignores non-resource prerequesites when tracking children" do
      top_level_rsrc = RDeployDoc::Resource.new(nil, :top_level, [])
      second_level_rsrc = RDeployDoc::Resource.new(nil, :second_level, [ top_level_rsrc, :another_predecessor ])

      top_level_rsrc.children.should == [ second_level_rsrc ]
      second_level_rsrc.children.should be_empty
    end

    
  end

end
