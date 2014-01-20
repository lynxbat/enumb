#
# ***********************************************************************
#  Copyright (c) 2014, Jason Young and Contributors. All Rights Reserved.
# ***********************************************************************
#

require "enumb/version"

module Enumb

  def enumerator(hash)
    raise 'Parameter must be hash' unless hash.is_a?(Hash)
    raise 'Multiple key/value pairs passed. Only single pair accepted.' unless hash.length == 1
    key, val = hash.first
    raise 'Enumerator key needs to be convertible to string' unless key.respond_to?(:to_s)
    create_class_method(key.to_s) {
      self.class_variable_get(String('@@__enum__' + key.to_s).to_sym)
    }
    self.class_variable_set(String('@@__enum__' + key.to_s).to_sym, val)
  end

  def to_descriptor(value)
    self.methods.each do |x|
      if ((self.send(x) rescue nil) == value)
        return x.to_s
      end
    end
  end

  def parse(descriptor)
    raise 'Descriptor needs to be convertible to string' unless descriptor.respond_to?(:to_s)
    self.class_variables.each do |x|
      if x.to_s.downcase == '@@__enum__' + descriptor.to_s.downcase
        return self.class_variable_get(x)
      end
    end
  end

  # Iterates using a block if provided, otherwise returns an array of enums
  def enums(&block)
    values = get_enums
    if block
      values.each do |v|
        yield v
      end
    else
      values
    end
  end

  # Returns true/false if provided enum is a part of this class
  def include?(enum_)
    enums.include?(enum_)
  end

  alias_method :each, :enums
  alias_method :map, :enums

  private

  def create_class_method(name, &block)
    self.class.send(:define_method, name, &block)
  end

  # Return enum class vars
  def get_enums
    # Find matching refs
    v = self.class_variables.find_all { |e| e.to_s.include? '__enum__' }
    # Lookup class variable from refs and return
    v.map { |x| class_variable_get(x) }
  end


  #decided not to limit in these ways, but;
  #if you want your enum sealed implement something similar
  #def inherited subclass
  #  raise "class #{subclass} cannot be derived from sealed class #{self}"
  #end
  #you may also want to add self.freeze if you are heading down this restrictive path.

end