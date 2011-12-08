# Require all the necessary code
module RDeployDoc

  RESOURCE_TYPES = [ :directory,
                     :file,
                     :link,
                     :package,
                     :service,
                     :node ]
end
require 'rdeploy_doc/resource'
require 'rdeploy_doc/package_resource'
require 'rdeploy_doc/service_resource'
require 'rdeploy_doc/file_system_resource'
require 'rdeploy_doc/directory_resource'
require 'rdeploy_doc/file_resource'
require 'rdeploy_doc/link_resource'
require 'rdeploy_doc/utils'
require 'rdeploy_doc/node_resource'
require 'rdeploy_doc/railtie' if defined?(Rails)
require 'prawn'

module RDeployDoc

  # Define the accessors and factory methods for each of the resources defined
  RESOURCE_TYPES.each do |resource|
    plural = Utils.pluralize(resource.to_s)
    resource_list_accessor = (resource == :node) ? "@node_resources ||= {}" : "@current_node.#{plural}"
    module_eval <<-EOF
      def #{plural} 
        #{resource_list_accessor}
      end
      def #{resource}(args)
        resource_inst = #{Utils.resource_class(resource)}.new(@current_description, resource_name(args), resource_prerequisites(args))
        @current_node = resource_inst if resource_inst.is_a?(RDeployDoc::NodeResource)
        yield resource_inst if block_given?
        @current_node.#{plural}[resource_inst.name] = resource_inst unless resource_inst.is_a?(RDeployDoc::NodeResource)
        #{plural}[resource_inst.name] = resource_inst if resource_inst.is_a?(RDeployDoc::NodeResource)
      end
    EOF
  end

  def desc(description) @current_description = description end

  def render_erb_template(template_file, output_file=nil)
    raise "Can't find template file: #{template_file}" if !File.exists?(template_file)
    raise "Cannot write to file: #{output_file}" if output_file && !File.writable?(File.dirname(output_file))

    template = nil
    File.open(template_file, 'r') { |f| template = ERB.new(f.read) }
    if output_file
      File.open(output_file, 'w') { |f| f.write template.result(binding) }
    else
      puts template.result(binding)
    end
  end

  def render_prawn_template(template_file, output_file)
    raise "Can't find template file: #{template_file}" if !File.exists?(template_file)
    raise "Cannot write to file: #{output_file}" if output_file && !File.writable?(File.dirname(output_file))
    template = File.read(template_file)
    Prawn::Document.generate(output_file) do |pdf|
      eval(template, binding, template_file)
    end
  end
  
  private

  # def unique_resources(resources)
  #   resources.values.inject([]) { |a,r| a.concat((r.ordered_prerequisites(r.class) << r)) }.uniq
  # end

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

