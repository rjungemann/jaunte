spec = Gem::Specification.new do |s|
  s.name = 'jaunte'
  s.version = '0.0.3'
  s.summary = "A utility to allow a user to quickly move from one directory to another."
  s.description = "A utility to allow a user to quickly move from one directory to another by remembering the most commonly-accessed directories."
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['bin/**/*'] +
    Dir['vendor/**/*.rb']
  s.require_path = 'lib'
  #s.autorequire = 'jaunte'
  s.executables = ['jaunte-append', 'jaunte-jump', 'jaunte-stat']
  s.has_rdoc = false
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.rdoc_options << '--title' <<  'jaunte -- move swiftly'
  s.author = "Roger Jungemann"
  s.email = "roger@thefifthcircuit.com"
  s.homepage = "http://thefifthcircuit.com"
end
