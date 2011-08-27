require 'spec_helper'

describe RDeployDoc::Utils do

  context "Pluralizing nouns" do
    
    it "should pluralize a noun ending in a 'y' as 'ies'" do
      RDeployDoc::Utils.pluralize('directory').should == 'directories'
    end

    it "should pluralize a noun not ending in a 'y' by appending an 's'" do
      RDeployDoc::Utils.pluralize('file').should == 'files'
    end

  end

  context "Constructing resource classes from symbols" do

    it "should respond with the Class name of the resource identified by a symbol" do
      RDeployDoc::Utils.resource_class(:file).should == RDeployDoc::FileResource
    end
  end

end
