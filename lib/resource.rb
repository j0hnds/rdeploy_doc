class Resource
  attr_reader :description, :name, :prerequisites

  def initialize(description, name, prerequisites)
    @description = description
    @name = name
    @prerequisites = prerequisites
  end

end
