# Introducing the dws-registry gem

The dws-registry is built upon the xml-registry gem, and is designed to automatically save the file after every set_key, delete_key, or import operation.

## Example

    require 'dws-registry'

    reg = DWSRegistry.new 'fun.xml'
    reg.to_xml
    #=> "<?xml version='1.0' encoding='UTF-8'?>\n<root></root>"
    reg.set_key 'subscriber/niko', 'druby://niko:353524'
    reg.to_xml
    #=> "<?xml version='1.0' encoding='UTF-8'?>\n<root><subscriber><niko>druby://niko:353524</niko></subscriber></root>"

When I exited the IRB session I observed the 'fun.xml' file which contained the XML from the above.

## Resources

* [jrobertson/dws-registry](https://github.com/jrobertson/dws-registry)
* [Introducing the xml-registry gem](http://www.jamesrobertson.eu/snippets/2012/01/18/1357hrs.html)

dwsregistry gem xml registry
