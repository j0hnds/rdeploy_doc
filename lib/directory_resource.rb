class DirectoryResource < FileSystemResource

  attr_accessor :content

  def initialize(description, name, prerequisites)
    super
  end

  def posix_mode
    format_posix_mode(FileSystemResource::DIRECTORY_RESOURCE_TYPE)
  end

end
