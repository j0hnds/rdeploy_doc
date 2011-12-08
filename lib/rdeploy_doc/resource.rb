module RDeployDoc

  class Resource
    attr_reader :description, :name, :prerequisites
    attr_accessor :children

    def initialize(description, name, prerequisites)
      @description = description
      @name = name
      @prerequisites = prerequisites
      @children = []
      @prerequisites.each { |p| p.children << self if p.is_a?(Resource) }
    end

    def ordered_prerequisites(clazz)
      @prerequisites.inject([]) { |a,p| a.concat((p.ordered_prerequisites(clazz) << p)) if p.is_a?(clazz); a }.uniq
    end

    def resource_type
      name = self.class.name
      name.slice(name.index('::')+2...name.index('Resource'))
    end

  end

end
