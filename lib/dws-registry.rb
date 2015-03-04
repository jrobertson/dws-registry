#!/usr/bin/env ruby

# file: dws-registry.rb

require 'time'
require 'xml-registry'

class DWSRegistry < XMLRegistry
  
  def initialize(filename='registry.xml', autosave: true)
    
    super()
    
    @autosave = autosave    
    
    if filename then

      @filename = filename      
      
      if File.exists? filename then
        load_xml(filename)
      else
        save()
      end      

    end
  end
  
  def get_key(path)
    
    e = super path
    c = e.attributes[:class]
    s = e.text
    
    return e if s.nil?    
    return s unless c
          
    h = {
      string: ->(x) {x},
      boolean: ->(x){ 
        case x
        when 'true' then true
        when 'false' then false
        else x
        end
      },
      number: ->(x){  x[/^[0-9]+$/] ? x.to_i : x.to_f },
      time:   ->(x) {Time.parse x}
    }
                            
    h[c.to_sym].call s
    
  end

  def set_key(path, value)
    
    value, type = case value.class.to_s.downcase.to_sym
    when :string     then value
    when :time       then ["#%s#" % value.to_s, :time]
    when :fixnum     then [value.to_s, :number]
    when :float      then [value.to_s, :number]      
    when :falseclass then [value.to_s, :boolean]
    when :trueclass  then [value.to_s, :boolean]
    end
    
    e = super(path, value)    

    type = find_class value unless type
    e.attributes[:class] = type if type
    
    save() if @autosave
    e
  end

  def delete_key(path)
    super(path)
    save() if @autosave
  end

  def save(filename=nil)
    @filename = filename if filename
    super(@filename)
  end

  def import(s)      
    super(s)
    save() if @autosave
  end
  
  def refresh()
    load_xml(@filename)    
  end
  
  private
  
  def add_value(key, value)
    e = @doc.root.element(key)
    e.text = value
    return e
  end
  
  def find_class(v)

    if v.to_i.to_s.length == v.length then :number
    elsif v.to_f.to_s.length == v.length then :number
    elsif v.downcase[/^(?:true|false|on|off|yes|no)$/] then :boolean
    elsif v[/^\#.*\#$/] then :time
    elsif v[/^\/\/job:\S+\s+https?:\/\//] then :job
    end
  end  

end