class FileSystemResource < Resource

  attr_accessor :path, :owner, :group, :mode

  def initialize(description, name, prerequisites)
    super
  end

end
