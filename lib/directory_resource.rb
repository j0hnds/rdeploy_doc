class DirectoryResource < FileSystemResource

  def initialize(description, name, prerequisites)
    super
  end

  def posix_mode
    format_posix_mode(true)
  end

end
