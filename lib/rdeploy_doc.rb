# Require all the necessary code
require 'rdeploy_doc/resource'
require 'rdeploy_doc/package_resource'
require 'rdeploy_doc/service_resource'
require 'rdeploy_doc/file_system_resource'
require 'rdeploy_doc/directory_resource'
require 'rdeploy_doc/file_resource'
require 'rdeploy_doc/link_resource'
require 'rdeploy_doc/utils'
require 'rdeploy_doc/railtie' if defined?(Rails)

module RDeployDoc

  RESOURCE_TYPES = [ :directory,
                     :file,
                     :link,
                     :package,
                     :service ]

  # Define the accessors and factory methods for each of the resources defined
  RESOURCE_TYPES.each do |resource|
    plural = Utils.pluralize(resource.to_s)
    module_eval <<-EOF
      def apply_to_#{plural}
        unique_resources(#{plural}).each { |d| yield d if block_given? } 
      end
      def #{plural} 
        @#{resource}_resources ||= {} 
      end
      def #{resource}(args)
        resource_inst = #{Utils.resource_class(resource)}.new(@current_description, resource_name(args), resource_prerequisites(args))
        yield resource_inst if block_given?
        #{plural}[resource_inst.name] = resource_inst
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
