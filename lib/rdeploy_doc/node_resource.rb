module RDeployDoc

  class NodeResource < Resource

    attr_accessor :child_resources

    def initialize(description, name, prerequsites)
      super
      @child_resources = []
    end

    RDeployDoc::RESOURCE_TYPES.select { |rt| rt != :node }.each do | resource |
      plural = Utils.pluralize(resource.to_s)
      module_eval <<-EOF
        def apply_to_#{plural}
          unique_resources(#{plural}).each { |d| yield d if block_given? } 
        end
        def top_level_#{plural}
          @#{resource}_resources.values.select { |r| r.prerequisites.empty? }
        end
        def #{plural}
          @#{resource}_resources ||= {}
        end
      EOF
    end

    def unique_resources(resources)
      resources.values.inject([]) { |a,r| a.concat((r.ordered_prerequisites(r.class) << r)) }.uniq
    end

  end

end
