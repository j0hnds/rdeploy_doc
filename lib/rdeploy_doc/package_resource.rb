module RDeployDoc

  class PackageResource < Resource

    attr_accessor :version

    def initialize(description, name, prerequisites)
      super
    end

  end

end
