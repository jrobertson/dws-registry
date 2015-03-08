Gem::Specification.new do |s|
  s.name = 'dws-registry'
  s.version = '0.2.4'
  s.summary = 'dws-registry'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('xml-registry', '~> 0.3', '>=0.3.1') 
  s.signing_key = '../privatekeys/dws-registry.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dws-registry'
  s.required_ruby_version = '>= 2.1.2'
end
