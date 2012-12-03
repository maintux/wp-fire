Gem::Specification.new do |s|
  s.name        = 'wp-fire'
  s.version     = '0.0.4'
  s.date        = '2012-12-01'
  s.summary     = "Wordpress theme generator with Coffee Script and Sass support"
  s.authors     = ["Massimo Maino"]
  s.email       = 'maintux@gmail.com'
  s.executables = ['wp_fire']
  s.files       = Dir['wp_fire.rb', 'lib/**/*', 'bin/*', 'generators/**/*']
  s.homepage    = 'https://github.com/maintux/wp-fire'
  s.has_rdoc    = false
  s.licenses    = 'GPL-2'
  s.add_dependency 'clamp'
  s.add_dependency 'thor'
  s.add_dependency 'filewatcher'
  s.add_dependency 'sass'
  s.add_dependency 'coffee-script'
end
