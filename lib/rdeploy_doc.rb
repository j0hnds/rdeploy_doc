# Require all the necessary code
require 'resource'
require 'package_resource'
require 'service_resource'
require 'file_system_resource'
require 'directory_resource'
require 'file_resource'
require 'link_resource'

module RDeployDoc
  module Utils
    
    def self.pluralize(noun)
      return noun[0...-1] << 'ies' if noun.end_with?('y')
      noun << 's'
    end
  
  end

  RESOURCE_TYPES = [ :directory,
                     :file,
                     :link,
                     :package,
                     :service ]

  # Define the accessors and factory methods for each of the resources defined
  RESOURCE_TYPES.each do |resource|
    plural = Utils.pluralize(resource.to_s)
    eval "def apply_to_#{plural}() unique_resources(#{plural}).each { |d| yield d if block_given?} end"
    # Define the resource accessors
    eval "def #{plural}() @#{resource}_resources ||= {} end"
    eval <<EOF 
  def #{resource}(args)
    resource = #{resource.capitalize}Resource.new(@current_description, resource_name(args), resource_prerequisites(args))
    yield resource if block_given?
    #{plural}[resource.name] = resource
  end
EOF
  end

  def desc(description) @current_description = description end
  
  private

  def unique_resources(resources)
    resources.values.inject([]) { |a,r| a.concat((r.ordered_prerequisites(r.class) << r)) }.uniq
  end

  def resource_name(args)
    name = args if args.is_a?(Symbol)
    name = args.to_sym if args.is_a?(String)
    name = args.keys.first.to_sym if args.is_a?(Hash)
    name
  end

  def resource_prerequisites(args)
    value = args.is_a?(Hash) ? args.values.first : []
    (value.is_a?(Array) ? value : [ value ])
  end

end
