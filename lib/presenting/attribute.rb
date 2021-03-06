module Presenting
  # represents an attribute meant to be read from a record
  # used for things like Grid and Details.
  # not intended for things like Form or FieldSearch
  class Attribute
    include Presenting::Configurable
    
    def name=(val)
      self.value ||= val # don't lazy define :value, because we're about to typecast here
      if val.is_a? Symbol
        @name = val.to_s.titleize
      else
        @name = val.to_s
      end
    end
    attr_reader :name
    
    # The short programmatic name for this field. Can be used as a CSS class, sorting name, etc.
    def id=(val)
      @id = val.to_s
    end
    
    def id
      @id ||= name.to_s.underscore.gsub(/[^a-z0-9]/i, '_').gsub(/__+/, '_').sub(/_$/, '')
    end
  
    # Where a field's value comes from. Depends heavily on the data type you provide.
    # - String: fixed value (as provided)
    # - Symbol: a method on the record (no arguments)
    # - Proc: a custom block that accepts the record as an argument
    attr_accessor :value
    
    def value_from(obj) #:nodoc:
      case value
      when Symbol
        obj.is_a?(Hash) ? obj[value] : obj.send(value)
      when String
        value
      when Proc
        value.call(obj)
      end
    end
    
    # whether html should be sanitize. right now this actually means html escaping.
    # consider: by default, do not sanitize if value is a String?
    attr_writer :sanitize
    def sanitize?
      unless defined? @sanitize
        @sanitize = Presenting::Defaults.sanitize_fields
      end
      @sanitize
    end
  end
end
