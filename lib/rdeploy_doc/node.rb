module RDeployDoc

  class Node < Resource

    attr_accessor :child_resources

    def initialize(description, name, prerequsites)
      super
      @child_resources = []
    end

  end

end
