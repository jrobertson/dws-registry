Gem::Specification.new do |s|
  s.name = 'dws-registry'
  s.version = '0.6.0'
  s.summary = 'An XML registry which stores the Ruby data type as ' + 
      'well as the value'
  s.authors = ['James Robertson']
  s.files = Dir['lib/dws-registry.rb']
  s.add_runtime_dependency('xml-registry', '~> 0.8', '>=0.8.0')
  s.add_runtime_dependency('requestor', '~> 0.5', '>=0.5.0')
  s.signing_key = '../privatekeys/dws-registry.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/dws-registry'
  s.required_ruby_version = '>= 2.1.2'
end
