module RDeployDoc

  class LinkResource < FileSystemResource

    attr_accessor :target

    def initialize(description, name, prerequisites)
      super
    end

    def posix_mode
      @mode ||= 0777 # Default to this mode if not set
      format_posix_mode(FileSystemResource::LINK_RESOURCE_TYPE)
    end

    private

    def targeted_name
      raise "target attribute must be specified for a link resource" if @target.nil? || @target.length == 0
      "#{File.basename(@path)} -> #{@target}"
    end

  end

end
