class Resource
  attr_reader :description, :name, :prerequisites

  def initialize(description, name, prerequisites)
    @description = description
    @name = name
    @prerequisites = prerequisites
  end

  def ordered_prerequisites(clazz)
    @prerequisites.inject([]) { |a,p| a.concat((p.ordered_prerequisites(clazz) << p)) if p.is_a?(clazz); a }.uniq
  end

end
