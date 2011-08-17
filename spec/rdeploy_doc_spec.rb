require 'spec_helper'

describe RDeployDoc do
  include RDeployDoc

  context "Factory Methods" do

    context "Directories" do

      it "should construct a directory resource with no description and no block" do
        dir = directory(:a_dir => :prereq)
        dir.should_not be_nil
        dir.is_a?(DirectoryResource)
        dir.description.should be_nil
        dir.name.should == :a_dir
        dir.prerequisites.should == [ :prereq ]
        directories[:a_dir].should == dir
      end

      it "should construct a directory resource with a description and a block" do
        desc 'Directory Description'
        dir = directory(:a_dir => :prereq) do |d|
          d.path = '/tmp'
          d.owner = 'root'
          d.group = 'developers'
          d.mode = 02775
        end
        dir.should_not be_nil
        dir.is_a?(DirectoryResource)
        dir.description.should == 'Directory Description'
        dir.name.should == :a_dir
        dir.path.should == '/tmp'
        dir.owner.should == 'root'
        dir.group.should == 'developers'
        dir.mode.should == 02775
        dir.prerequisites.should == [ :prereq ]
        directories[:a_dir].should == dir
      end

    end

    context "Files" do

      it "should construct a file resource with no description and no block" do
        f = file(:a_file => :prereq)
        f.should_not be_nil
        f.is_a?(FileResource)
        f.description.should be_nil
        f.name.should == :a_file
        f.prerequisites.should == [ :prereq ]
        files[:a_file].should == f
      end

      it "should construct a file resource with a description and a block" do
        desc 'File Description'
        f = file(:a_file => :prereq) do |the_file|
          the_file.path = '/tmp'
          the_file.owner = 'root'
          the_file.group = 'developers'
          the_file.mode = 02775
        end
        f.should_not be_nil
        f.is_a?(FileResource)
        f.description.should == 'File Description'
        f.name.should == :a_file
        f.path.should == '/tmp'
        f.owner.should == 'root'
        f.group.should == 'developers'
        f.mode.should == 02775
        f.prerequisites.should == [ :prereq ]
        files[:a_file].should == f
      end

    end

    context "Packages" do

      it "should construct a package resource with no description and no block" do
        p = package(:a_package => :prereq)
        p.should_not be_nil
        p.is_a?(PackageResource)
        p.description.should be_nil
        p.name.should == :a_package
        p.prerequisites.should == [ :prereq ]
        packages[:a_package].should == p
      end

      it "should construct a package resource with a description and a block" do
        desc 'Package Description'
        p = package(:a_package => :prereq) do |the_package|
          the_package.version = '1.1.2'
        end
        p.should_not be_nil
        p.is_a?(PackageResource)
        p.description.should == 'Package Description'
        p.name.should == :a_package
        p.version.should == '1.1.2'
        p.prerequisites.should == [ :prereq ]
        packages[:a_package].should == p
      end

    end

    context "Service" do

      it "should construct a service resource with no description and no block" do
        s = service(:a_service => :prereq)
        s.should_not be_nil
        s.is_a?(ServiceResource)
        s.description.should be_nil
        s.name.should == :a_service
        s.prerequisites.should == [ :prereq ]
        services[:a_service].should == s
      end

      it "should construct a package resource with a description and a block" do
        desc 'Service Description'
        s = service(:a_service => :prereq) do |the_service|
        end
        s.should_not be_nil
        s.is_a?(ServiceResource)
        s.description.should == 'Service Description'
        s.name.should == :a_service
        s.prerequisites.should == [ :prereq ]
        services[:a_service].should == s
      end

    end

  end

  context "Prerequisite Extraction" do

    it "should return the prerequisites as an empty array if a hash is not specified as an argument" do
      ps = resource_prerequisites(:the_name)
      ps.should == []
    end

    it "should return the prerequisite as an array of objects if a hash is specified with a symbol prerequisite" do
      ps = resource_prerequisites(:the_name => :the_pre)
      ps.should == [ :the_pre ]
    end

    it "should return the prerequisite as an array of strings if a hash is specified with a string prerequisite" do
      ps = resource_prerequisites(:the_name => 'the_pre')
      ps.should == [ 'the_pre' ]
    end

    it "should return the prerequisites as an array of the specific types even if all the prerequisites are not symbols" do
      ps = resource_prerequisites(:the_name => [ 'the_pre', :another_pre, 'yet_another_pre' ])
      ps.should == ['the_pre', :another_pre, 'yet_another_pre' ]
    end

    it "should return an empty prerequisite array when the hash argument has an empty array" do
      ps = resource_prerequisites(:the_name => [])
      ps.should == []
    end

  end

  context "Resource Name Extraction" do

    it "should return the resource name as a symbol when specified as a symbol" do
      r_name = resource_name(:the_name)
      r_name.is_a?(Symbol).should be_true
      r_name.should == :the_name
    end

    it "should return the resource name as a symbol when specified as a string" do
      r_name = resource_name('the_name')
      r_name.is_a?(Symbol).should be_true
      r_name.should == :the_name
    end

    it "should return the resource name as a symbol when the argument passed is a hash with symbol keys" do
      r_name = resource_name(:the_name => :the_dependency)
      r_name.is_a?(Symbol).should be_true
      r_name.should == :the_name
    end

    it "should return the resource name as a symbol when the argument passed is a hash with string keys" do
      r_name = resource_name('the_name' => :the_dependency)
      r_name.is_a?(Symbol).should be_true
      r_name.should == :the_name
    end

  end

  context "Resource Accessors" do

    it "should allow access to the hash of directory resources" do
      dirs = directories
      dirs.should_not be_nil
      dirs.is_a?(Hash).should be_true
      dirs.should be_empty
      directories[:an_entry] = 'a directory'
      directories.should_not be_empty
      directories[:an_entry].should == 'a directory'
    end

    it "should allow access to the hash of file resources" do
      file_hash = files
      file_hash.should_not be_nil
      file_hash.is_a?(Hash).should be_true
      file_hash.should be_empty
      files[:an_entry] = 'a file'
      files.should_not be_empty
      files[:an_entry].should == 'a file'
    end

    it "should allow access to the hash of package resources" do
      package_hash = packages
      package_hash.should_not be_nil
      package_hash.is_a?(Hash).should be_true
      package_hash.should be_empty
      packages[:an_entry] = 'a package'
      packages.should_not be_empty
      packages[:an_entry].should == 'a package'
    end

    it "should allow access to the hash of service resources" do
      service_hash = services
      service_hash.should_not be_nil
      service_hash.is_a?(Hash).should be_true
      service_hash.should be_empty
      services[:an_entry] = 'a service'
      services.should_not be_empty
      services[:an_entry].should == 'a service'
    end

  end

  context "Apply Method" do

    before(:each) do 
      directory :instance_directory do |d|
        d.path = "/var/www/abaqis"
        d.owner = 'root'
        d.group = 'developers'
        d.mode = 02755
      end
      directory :releases_directory => directories[:instance_directory] do |d|
        d.path = "/var/www/abaqis/releases"
        d.owner = 'root'
        d.group = 'developers'
        d.mode = 02755
      end
      directory :shared_directory => directories[:instance_directory] do |d|
        d.path = "/var/www/abaqis/shared"
        d.owner = 'root'
        d.group = 'developers'
        d.mode = 02755
      end
      directory :shared_config_directory => directories[:shared_directory] do |d|
        d.path = "/var/www/abaqis/shared/config"
        d.owner = 'root'
        d.group = 'developers'
        d.mode = 02755
      end
      file :bundle_config => directories[:shared_config_directory] do |f|
        f.path = "/var/www/abaqis/shared/config/bundle_config"
        f.owner = 'root'
        f.group = 'developers'
        f.mode = 0644
      end
    end
    
    it "should apply a block of code to the ordered set of directories" do
      paths = []
      apply_to_directories do |d|
        paths << d.path
      end
      paths.should == [ "/var/www/abaqis",
                        "/var/www/abaqis/releases",
                        "/var/www/abaqis/shared",
                        "/var/www/abaqis/shared/config" ]
    end

    it "should apply a block of code to the ordered set of files" do
      paths = []
      apply_to_files do |f|
        paths << f.path
      end
      paths.should == [ "/var/www/abaqis/shared/config/bundle_config" ]
    end
  end
end
