Gem::Specification.new do |s|
  s.name = 'dws-registry'
  s.version = '0.1.3'
  s.summary = 'dws-registry'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('xml-registry') 
  s.signing_key = '../privatekeys/dws-registry.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dws-registry'
end
