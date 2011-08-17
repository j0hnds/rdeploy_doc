require "spec_helper"

describe FileSystemResource do
  
  it "should require creation with a description, name and set of prerequisites" do
    resource = FileSystemResource.new('The description', :name, [ :pre1, :pre2 ])

    resource.description.should == 'The description'
    resource.name.should == :name
    resource.prerequisites.should == [ :pre1, :pre2 ]
  end

  context "Output Formatting" do

    context "Mode formatting" do

      it "should format the mode for a simple file" do
        fr = FileResource.new(nil, :name, [])

        fr.mode = 0000
        fr.posix_mode.should == '----------'

        fr.mode = 0100
        fr.posix_mode.should == '---x------'

        fr.mode = 0111
        fr.posix_mode.should == '---x--x--x'

        fr.mode = 0222
        fr.posix_mode.should == '--w--w--w-'

        fr.mode = 0444
        fr.posix_mode.should == '-r--r--r--'

        fr.mode = 0644
        fr.posix_mode.should == '-rw-r--r--'

      end

      it "should format the mode for a directory" do
        dr = DirectoryResource.new(nil, :name, [])

        dr.mode = 0000
        dr.posix_mode.should == 'd---------'

        dr.mode = 0100
        dr.posix_mode.should == 'd--x------'

        dr.mode = 0111
        dr.posix_mode.should == 'd--x--x--x'

        dr.mode = 0222
        dr.posix_mode.should == 'd-w--w--w-'

        dr.mode = 0444
        dr.posix_mode.should == 'dr--r--r--'

        dr.mode = 0644
        dr.posix_mode.should == 'drw-r--r--'

        dr.mode = 02775
        dr.posix_mode.should == 'drwxrwsr-x'

        dr.mode = 04775
        dr.posix_mode.should == 'drwsrwxr-x'

        dr.mode = 06775
        dr.posix_mode.should == 'drwsrwsr-x'
      end
    end
    
  end

end
