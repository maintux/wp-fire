module WpFire
  ROOT = File.expand_path(File.join(File.dirname(__FILE__)))
  autoload :Generator, 'wp_fire/generator'
  autoload :Compiler, 'wp_fire/compiler'
  autoload :MainCommand, 'wp_fire/main_command'
end