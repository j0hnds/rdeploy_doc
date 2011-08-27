module RDeployDoc
  module Utils
    
    def self.pluralize(noun)
      return noun[0...-1] << 'ies' if noun.end_with?('y')
      noun << 's'
    end
  
  end

end
