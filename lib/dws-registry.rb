#!/usr/bin/env ruby

# file: dws-registry.rb

require 'time'
require 'xml-registry'
require 'rscript'
require 'json'
require 'requestor'
require 'rxfreader'


class DWSRegistry < XMLRegistry
  include RXFRead

  def initialize(filename='registry.xml', autosave: true, debug: false)

    super(debug: debug)

    @autosave = autosave

    if filename then

      @filename = filename

      if FileX.exists? filename then
        load_xml(filename)
      else
        save()
      end

    end
  end

  def gem_register(gemfile)

    if gemfile =~ /^\w+\:\/\// then

      code = Requestor.read(File.dirname(gemfile)) do |x|
        x.require File.basename(gemfile)
      end

      eval code

    else

      require gemfile

    end

    if defined? RegGem::register then

      self.import RegGem::register
      true

    else
      nil
    end

  end

  def get_key(path, auto_detect_type: false)

    e = super path

    return e unless auto_detect_type

    raw_c = e.attributes[:type]

    c = raw_c if raw_c
    s = e.text

    return e if e.elements.length > 0 or s.nil?
    return s unless c

    h = {
      string: ->(x) {x},
      boolean: ->(x){
        case x
        when 'true' then true
        when 'false' then false
        when 'on' then true
        when 'off' then false
        else x
        end
      },
      number: ->(x){  x[/^[0-9]+$/] ? x.to_i : x.to_f },
      time:   ->(x) {Time.parse x},
      json:   ->(x) {JSON.parse x}
    }

    h[c.to_sym].call s

  end

  def set_key(path, value)

    if @debug then
      puts 'inside set_key path: ' + path.inspect
      puts '  value: '  + value.inspect
      puts '  value.class : '  + value.class.inspect
    end

    value, type = case value.class.to_s.downcase.to_sym
    when :string     then value
    when :time       then ["#%s#" % value.to_s, :time]
    when :fixnum     then [value.to_s, :number]
    when :integer    then [value.to_s, :number]
    when :float      then [value.to_s, :number]
    when :falseclass then [value.to_s, :boolean]
    when :trueclass  then [value.to_s, :boolean]
    when :array       then ["%s" % value.to_json, :json]
    else value
    end

    e = super(path, value)

    type = find_type value unless type
    e.attributes[:type] = type.to_s if type
    e.parent.attributes[:last_modified] = Time.now.to_s

    save() if @autosave

    onchange = e.attributes[:onchange]

    if onchange then
      RScript.new.run onchange.sub('$value', value).split
    end

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

  def find_type(v)

    puts 'v: ' + v.inspect if @debug

    if v[/^\d+$/] and v.to_i.to_s.length == v.length then :number
    elsif v[/^\d+\.\d+$/] and v.to_f.to_s.length == v.length then :number
    elsif v.downcase[/^(?:true|false|on|off|yes|no)$/] then :boolean
    elsif v[/^\#.*\#$/] then :time
    elsif v[/^\/\/job:\S+\s+https?:\/\//] then :job
    elsif v[/^\[.*\]$/] then :json
    end
  end


end
