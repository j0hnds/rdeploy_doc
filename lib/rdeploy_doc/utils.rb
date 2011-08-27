module RDeployDoc
  module Utils
    
    def self.pluralize(noun)
      return noun[0...-1] << 'ies' if noun.end_with?('y')
      noun << 's'
    end
  
    def self.resource_class(resource_symbol)
      eval "#{resource_symbol.capitalize}Resource"
    end

  end

end
