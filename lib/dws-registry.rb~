#!/usr/bin/env ruby

# file: dws-registry.rb


require 'xml-registry'

class DWSRegistry < XMLRegistry
  
  def initialize(filename=nil)
    
    super()
    if filename then
      @filename = filename
      load_xml(filename)
    end
  end

  def set_key(path, value)
    super(path, value)
    save()
  end

  def delete_key(path)
    super(path)
    save()
  end

  def save()
    super(@filename)
  end

  def import(s)      
    super(s)
    save()
  end
  
  def refresh()
    load_xml(@filename)    
  end  

end


